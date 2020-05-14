require "csv"

class ContentItemsCSVPresenter
  include MetricsFormatterHelper
  include OrganisationsHelper

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
      I18n.t("row_headers.title") => raw_field(:title),
      I18n.t("row_headers.organisation") => lambda do |result_row|
        organisation_title(@organisations, result_row[:organisation_id])
      end,
      I18n.t("row_headers.govuk_url") => lambda do |result_row|
        url(result_row[:base_path])
      end,
      I18n.t("row_headers.content_data_url") => lambda do |result_row|
        content_data_link(result_row[:base_path])
      end,
      I18n.t("row_headers.document_type") => raw_field(:document_type),
      I18n.t("metrics.upviews.short_title") => raw_field(:upviews),
      I18n.t("metrics.pviews.short_title") => raw_field(:pviews),
      I18n.t("metrics.pageviews_per_visit.short_title") => lambda do |result_row|
        Calculator::PageviewsPerVisit.calculate(
          pageviews: result_row[:pviews], unique_pageviews: result_row[:upviews],
        )
      end,
      I18n.t("metrics.percentage_users_searched.title") => lambda do |result_row|
        percentage_users_searched(result_row[:searches], result_row[:upviews])
      end,
      I18n.t("metrics.satisfaction.short_title") => lambda do |result_row|
        format_metric_value("satisfaction", result_row[:satisfaction])
      end,
      I18n.t("metrics.useful_yes.title") => raw_field(:useful_yes),
      I18n.t("metrics.useful_no.title") => raw_field(:useful_no),
      I18n.t("metrics.searches.short_title") => raw_field(:searches),
      I18n.t("metrics.feedex.short_title") => raw_field(:feedex),
      I18n.t("row_headers.feedback_explorer_url") => lambda do |result_row|
        feedback_comments_link(result_row[:base_path])
      end,
      I18n.t("metrics.reading_time.short_title") => lambda do |result_row|
        format_duration(result_row[:reading_time])
      end,
      I18n.t("metrics.words.short_title") => raw_field(:word_count),
      I18n.t("metrics.pdf_count.short_title") => raw_field(:pdf_count),
    }

    CSV.generate do |csv|
      csv << fields.keys

      @data_enum.each do |result_row|
        csv << fields.values.map { |value_callable| value_callable.call(result_row) }
      end
    end
  end

  def filename
    sprintf("content-data-export-from-%<from>s-to-%<to>s-from-%<org>s%<document_type>s", from: @date_range.from, to: @date_range.to, org: organisation_title(@organisations, @organisation_id).parameterize, document_type: @document_type.present? ? "-in-#{@document_type.tr('_', '-')}" : "")
  end

private

  def raw_field(name)
    ->(result_row) { result_row[name] }
  end

  def url(base_path)
    "#{Plek.new.website_root}#{base_path}"
  end

  def content_data_link(base_path)
    base = Plek.new.external_url_for("content-data")

    base + Rails.application.routes.url_helpers.metrics_path(
      # Remove / from the start of the base_path, as the url helper
      # adds it in
      base_path[1..-1],
    )
  end

  def feedback_comments_link(base_path)
    host = Plek.new.external_url_for("support")
    from = @date_range.from
    to = @date_range.to
    path = CGI.escape(base_path)
    "#{host}/anonymous_feedback?from=#{from}&to=#{to}&paths=#{path}"
  end

  def percentage_users_searched(searches, unique_pageviews)
    value = Calculator::AverageSearchesPerUser.calculate(
      searches: searches, unique_pageviews: unique_pageviews,
    )

    number_to_percentage(value, precision: 2)
  end
end
