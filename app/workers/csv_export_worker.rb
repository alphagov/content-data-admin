class CsvExportWorker
  include Sidekiq::Worker

  def perform(search_params, recipient_address)
    document_types = FetchDocumentTypes.call[:document_types]
    organisations = FetchOrganisations.call[:organisations]

    content_items = FindContent.enum(search_params)
    presenter = ContentItemsCSVPresenter.new(
      content_items,
      search_params,
      document_types,
      organisations
    )

    csv_string = presenter.csv_rows
    file_url = 'https://somelink.com'

    # Send email with link
    ContentCsvMailer.content_csv_email(recipient_address, file_url).deliver_now
  end
end
