class SingleContentItemPresenter
  include MetricsFormatterHelper

  attr_reader :date_range,
    :metrics,
    :feedex_series,
    :searches_series,
    :pviews_series,
    :satisfaction_series,
    :upviews_series

  def total_upviews
    @metrics['upviews'][:value]
  end

  def total_pviews
    @metrics['pviews'][:value]
  end

  def total_searches
    @metrics['searches'][:value]
  end

  def total_satisfaction
    @metrics['satisfaction'][:value]
  end

  def total_feedex
    @metrics['feedex'][:value]
  end

  def upviews_context
    I18n.t("metrics.upviews.context", percent_org_views: 2.74)
  end

  def satisfaction_context
    I18n.t("metrics.satisfaction.context", total_responses: 700)
  end

  def searches_context
    I18n.t("metrics.searches.context", percent_users_searched: on_page_search_rate)
  end

  def feedex_context
    I18n.t("metrics.feedex.context")
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

  def initialize(single_page_data, date_range)
    @single_page_data = single_page_data

    @date_range = date_range
    @metrics = parse_metrics(
      single_page_data[:time_series_metrics],
      single_page_data[:edition_metrics]
    )

    parse_time_series
  end

  def publishing_app
    publishing_app = @single_page_data[:metadata][:publishing_app]

    publishing_app.present? ? publishing_app.capitalize.tr('-', ' ') : 'Unknown'
  end

  def title
    metadata[:title]
  end

  def base_path
    metadata[:base_path]
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

private

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
        'value': format_metric_value(metric[:name], metric[:total]),
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

  def parse_time_series
    @upviews_series = get_chart_presenter(@metrics['upviews'][:time_series], 'upviews')
    @pviews_series = get_chart_presenter(@metrics['pviews'][:time_series], 'pviews')
    @searches_series = get_chart_presenter(@metrics['searches'][:time_series], 'searches')
    @feedex_series = get_chart_presenter(@metrics['feedex'][:time_series], 'feedex')
    @satisfaction_series = get_chart_presenter(@metrics['satisfaction'][:time_series], 'satisfaction')
  end

  def get_chart_presenter(time_series, metric)
    ChartPresenter.new(json: time_series, metric: metric, from: date_range.from, to: date_range.to)
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end
