require 'csv'

class ContentItemsCSVPresenter
  def initialize(data_enum, date_range, document_types, organisations)
    @data_enum = data_enum
    @date_range = date_range
    @document_types = document_types
    @organisations = organisations
  end

  def csv_rows
    Enumerator.new do |yielder|
      yielder << CSV.generate_line(
        [
          'Title',
          'URL',
          'Content Data Link',
          'Document Type',
          'Upviews',
          'Satisfaction',
          'Satisfaction Score Responses',
          'Searches'
        ]
      )

      @data_enum.each do |result_row|
        yielder << CSV.generate_line(
          [
            result_row[:title],
            result_row[:base_path],
            content_data_link(result_row[:base_path]),
            result_row[:document_type],
            result_row[:upviews],
            result_row[:satisfaction_score_responses],
            result_row[:searches],
          ]
        )
      end
    end
  end

  def content_data_link(base_path)
    base = Plek.new.external_url_for('content-data-admin')

    base + Rails.application.routes.url_helpers.metrics_path(
      # Remove / from the start of the base_path, as the url helper
      # adds it in
      base_path[1..-1]
    )
  end
end
