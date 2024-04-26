require "prometheus/client"
require "prometheus/client/push"

class CsvExportWorker
  include FileStorage
  include Sidekiq::Worker

  sidekiq_options retry: 0
  sidekiq_options queue: "export_csv"

  def perform(search_params, recipient_address, start_time_string)
    search_params = search_params.symbolize_keys
    presenter = build_csv_presenter(search_params)
    start_time = Time.zone.parse(start_time_string)

    basename = presenter.filename
    csv_string = presenter.csv_rows

    file_url = upload_csv_to_s3(basename, csv_string)

    # Send email with link
    ContentCsvMailer.content_csv_email(recipient_address, file_url).deliver_now

    elapsed_time_seconds = (Time.zone.now - start_time).truncate
    push_metrics_to_pushgateway(elapsed_time_seconds)
  end

  def build_csv_presenter(search_params)
    document_types = FetchDocumentTypes.call[:document_types]
    organisations = FetchOrganisations.call[:organisations]

    content_items = FindContent.enum(search_params)
    ContentItemsCSVPresenter.new(
      content_items,
      search_params,
      document_types,
      organisations,
    )
  end

  def push_metrics_to_pushgateway(elapsed_time_seconds)
    prometheus_registry = Prometheus::Client.registry

    histogram = if Prometheus::Client.registry.exist?(:content_data_admin_histogram_v1)
                  Prometheus::Client.registry.get(:content_data_admin_histogram_v1)
                else
                  Prometheus::Client.registry.histogram(
                    :content_data_admin_histogram_v1,
                    docstring: "Time it takes to export a CSV file in seconds",
                    labels: %i[time_stamp],
                    buckets: [300, 600, 900, 1800, 2700, 3600], # 5 mins, 10mins 15mins, 30mins, 45mins, 60mins
                  )
                end

    timestamp_label = Time.zone.now.to_s
    histogram.with_labels(time_stamp: timestamp_label).observe(elapsed_time_seconds)

    Prometheus::Client::Push.new(
      job: "csv_export_duration_seconds",
      gateway: ENV.fetch("PROMETHEUS_PUSHGATEWAY_URL"),
    ).add(prometheus_registry)
  end
end
