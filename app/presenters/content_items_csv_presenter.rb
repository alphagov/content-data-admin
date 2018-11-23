require 'csv'

class ContentItemsCSVPresenter
  def initialize(data_enum, date_range, document_types, organisations)
    @data_enum = data_enum
    @date_range = date_range
    @document_types = document_types
    @organisations = organisations
  end

  def raw_field(name)
    lambda { |result_row| result_row[name] }
  end

  def csv_rows
    fields = {
      'Title' => raw_field(:title),
      'URL' => raw_field(:row),
      'Content Data Link' => lambda do |result_row|
        content_data_link(result_row[:base_path])
      end,
      'Document Type' => raw_field(:document_type),
      'Upviews' => raw_field(:upviews),
      'Satisfaction' => raw_field(:satisfaction),
      'Satisfaction Score Responses' => raw_field(:satisfaction_score_responses),
      'Searches' => raw_field(:searches),
      'Link to feedback comments' => lambda do |result_row|
        feedback_comments_link(result_row[:base_path])
      end,
    }

    Enumerator.new do |yielder|
      yielder << CSV.generate_line(fields.keys)

      @data_enum.each do |result_row|
        yielder << CSV.generate_line(
          fields.values.map { |value_callable| value_callable.call(result_row) }
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

  def feedback_comments_link(base_path)
    host = Plek.new.external_url_for('support')
    from = @date_range.from
    to = @date_range.to
    path = CGI.escape(base_path)
    "#{host}/anonymous_feedback?from=#{from}&to=#{to}&paths=#{path}"
  end
end
