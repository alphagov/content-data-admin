class SingleContentItemPresenter
  include MetricsFormatterHelper
  include ExternalLinksHelper

  attr_reader :date_range

  def initialize(current_period_data, previous_period_data, date_range)
    @single_page_data = current_period_data

    @date_range = date_range
    @metrics = parse_metrics(
      current_period_data[:time_series_metrics],
      current_period_data[:edition_metrics]
    )
    @previous_metrics = parse_metrics(
      previous_period_data[:time_series_metrics],
      previous_period_data[:edition_metrics]
    )
  end

  def total_upviews
    number_with_delimiter @metrics['upviews'][:value]
  end

  def total_pviews
    number_with_delimiter @metrics['pviews'][:value]
  end

  def total_searches
    number_with_delimiter @metrics['searches'][:value]
  end

  def total_satisfaction
    number_to_percentage(@metrics['satisfaction'][:value] * 100, precision: 0)
  end

  def total_feedex
    number_with_delimiter @metrics['feedex'][:value]
  end

  def total_words
    number_with_delimiter @metrics['words'][:value]
  end

  def total_pdf_count
    number_with_delimiter @metrics['pdf_count'][:value]
  end

  def upviews_context
    I18n.t("metrics.upviews.context", percent_org_views: 2.74)
  end

  def satisfaction_context
    I18n.t("metrics.satisfaction.context", total_responses: useful_yes_no_total)
  end

  def satisfaction_short_context
    I18n.t("metrics.satisfaction.short_context", total_responses: useful_yes_no_total)
  end

  def searches_context
    I18n.t("metrics.searches.context", percent_users_searched: on_page_search_rate)
  end

  def feedex_context
    I18n.t("metrics.feedex.context")
  end

  def feedback_explorer_href
    host = Plek.new.external_url_for('support')
    template = Addressable::Template.new(
      "#{host}/anonymous_feedback{?from,to,paths}"
    )
    query = {
      paths: base_path,
      from: @date_range.from,
      to: @date_range.to
    }
    template.expand(query).to_s
  end

  def period
    I18n.t("metrics.show.time_periods.#{@date_range.time_period}.reference")
  end

  def metric_title(metric_name)
    I18n.t("metrics.#{metric_name}.title")
  end

  def metric_short_title(metric_name)
    I18n.t("metrics.#{metric_name}.short_title")
  end

  def trend_percentage(metric_name)
    current_value = @metrics[metric_name][:value]
    previous_value = @previous_metrics[metric_name][:value]
    calculate_trend_percentage(current_value, previous_value)
  end

  def edit_url
    edit_url_for(
      content_id: metadata[:content_id],
      publishing_app: metadata[:publishing_app]
    )
  end

  def edit_label
    edit_label_for(publishing_app: metadata[:publishing_app])
  end

  def title
    metadata[:title]
  end

  def base_path
    metadata[:base_path]
  end

  def link_text(metric_name)
    I18n.t("metrics.#{metric_name}.title").try(:downcase)
  end

  def document_type
    metadata[:document_type].tr('_', ' ').capitalize
  end

  def published_at
    format_date(metadata[:first_published_at])
  end

  def last_updated
    format_date(metadata[:public_updated_at])
  end

  def publishing_organisation
    metadata[:primary_organisation_title]
  end

  def status; end

  def get_chart(metric_name)
    time_series = @metrics[metric_name][:time_series]
    ChartPresenter.new(json: time_series, metric: metric_name, date_range: date_range)
  end

private

  def useful_yes_no_total
    @metrics['useful_yes'][:value] + @metrics['useful_no'][:value]
  end

  def on_page_search_rate
    metric_value = self.total_searches
    secondary_metric_value = self.total_pviews

    return 0 if metric_value.to_i.zero? || secondary_metric_value.to_i.zero?
    search_rate = (metric_value.to_f / secondary_metric_value.to_f) * 100
    search_rate.round(2)
  end

  def metadata
    @metadata ||= @single_page_data[:metadata]
  end

  def parse_metrics(time_series_metrics, edition_metrics)
    metrics = {}
    time_series_metrics.each do |metric|
      metrics[metric[:name]] = {
        'value': metric[:total],
        'time_series': metric[:time_series]
      }
    end

    edition_metrics.each do |metric|
      metrics[metric[:name]] = {
        'value': format_metric_value(metric[:name], metric[:value]),
        'time_series': nil
      }
    end
    metrics
  end

  def calculate_trend_percentage(current_value, previous_value)
    previous_value.to_f <= 0 ? 0 : ((current_value.to_f / previous_value.to_f) - 1) * 100
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end
