require 'csv'

class ContentItemsCSVPresenter
  def initialize(data_enum, search_params, document_types, organisations)
    @data_enum = data_enum
    @document_type = search_params[:document_type]
    @organisation_id = search_params[:organisation_id]
    @date_range = DateRange.new(search_params[:date_range])
    @document_types = document_types
    @organisations = organisations
  end

  def csv_rows
    fields = {
      'Title' => raw_field(:title),
      'URL' => lambda do |result_row|
        url(result_row[:base_path])
      end,
      'Content Data Link' => lambda do |result_row|
        content_data_link(result_row[:base_path])
      end,
      'Document Type' => raw_field(:document_type),
      I18n.t('metrics.upviews.short_title') => raw_field(:upviews),
      I18n.t('metrics.satisfaction.short_title') => raw_field(:satisfaction),
      'User satisfaction score responses' => raw_field(:satisfaction_score_responses),
      I18n.t('metrics.searches.short_title') => raw_field(:searches),
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

  def filename
    "content-data-export-from-%<from>s-to-%<to>s-from-%<org>s%<document_type>s.csv" % {
      from: @date_range.from,
      to: @date_range.to,
      org: organisation_title.parameterize,
      document_type: @document_type.present? ? "-in-#{@document_type.tr('_', '-')}" : ''
    }
  end

private

  def raw_field(name)
    lambda { |result_row| result_row[name] }
  end

  def organisation_title
    organisation_data = @organisations.find do |org|
      org[:organisation_id] == @organisation_id
    end

    organisation_data[:title]
  end

  def url(base_path)
    "#{Plek.new.website_root}#{base_path}"
  end

  def content_data_link(base_path)
    base = Plek.new.external_url_for('content-data-admin')

    base + Rails.application.routes.url_helpers.single_page_path(
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
