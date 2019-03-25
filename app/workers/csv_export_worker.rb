require 'fog/aws'

class CsvExportWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0
  sidekiq_options queue: 'export_csv'

  def perform(search_params, recipient_address)
    search_params = search_params.symbolize_keys
    presenter = build_csv_presenter(search_params)

    basename = presenter.filename
    csv_string = presenter.csv_rows

    file_url = upload_to_s3("#{basename}.csv", csv_string)

    # Send email with link
    ContentCsvMailer.content_csv_email(recipient_address, file_url).deliver_now
  end

  def build_csv_presenter(search_params)
    document_types = FetchDocumentTypes.call[:document_types]
    organisations = FetchOrganisations.call[:organisations]

    content_items = FindContent.enum(search_params)
    ContentItemsCSVPresenter.new(
      content_items,
      search_params,
      document_types,
      organisations
    )
  end

  def upload_to_s3(filename, body)
    connection = Fog::Storage.new(
      provider: 'AWS',
      region: ENV['AWS_REGION'],
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    directory = connection.directories.get(ENV['AWS_CSV_EXPORT_BUCKET_NAME'])

    timestamp = Time.now.utc.strftime('%Y-%m-%d-%H-%M-%S')
    key = "#{timestamp}/#{filename}"

    file = directory.files.create(
      key: key,
      body: body,
      public: true,
      content_disposition: "attachment; filename=\"#{filename}\"",
      content_type: 'text/csv'
    )

    file.public_url
  end
end
