require "fog/aws"

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
    GovukStatsd.timing("monitor.csv.download.ms", elapsed_time_seconds * 1000)
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
end
