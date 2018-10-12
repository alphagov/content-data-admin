class SingleContentItemPresenter
  include MetricsFormatterHelper

  attr_reader :title,
              :date_range,
              :metadata,
              :metrics,
              :feedex_series,
              :searches_series,
              :pviews_series,
              :satisfaction_series,
              :upviews_series,
              :searches_glance_metric,
              :upviews_glance_metric,
              :satisfaction_glance_metric,
              :feedex_glance_metric



  def initialize(single_page_data, date_range)
    @single_page_data = single_page_data

    @date_range = date_range
    @metrics = parse_metrics(
      single_page_data[:time_series_metrics],
      single_page_data[:edition_metrics]
    )

    get_metadata
    parse_time_series
    add_glance_metric_presenters
  end

  def publishing_app
    publishing_app = @single_page_data[:metadata][:publishing_app]

    publishing_app.present? ? publishing_app.capitalize.tr('-', ' ') : 'Unknown'
  end

private

  def get_metadata
    metadata = @single_page_data[:metadata]
    @title = metadata[:title]
    @metadata = {
      base_path: metadata[:base_path],
      document_type: metadata[:document_type].tr('_', ' ').capitalize,
      published_at: format_date(metadata[:first_published_at]),
      last_updated: format_date(metadata[:public_updated_at]),
      publishing_organisation: metadata[:primary_organisation_title],
    }
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

  def add_glance_metric_presenters
    time_period = @date_range.time_period
    @upviews_glance_metric = GlanceMetricPresenter.new('upviews', @metrics['upviews'][:value], time_period)
    @satisfaction_glance_metric = GlanceMetricPresenter.new(
      'satisfaction',
      @metrics['satisfaction'][:value],
      time_period,
      context: {
        total_responses: @metrics['useful_yes'][:value] + @metrics['useful_no'][:value]
      }
    )
    @searches_glance_metric = GlanceMetricPresenter.new('searches', @metrics['searches'][:value], time_period)
    @feedex_glance_metric = GlanceMetricPresenter.new('feedex', @metrics['feedex'][:value], time_period)
  end

  def get_chart_presenter(time_series, metric)
    ChartPresenter.new(json: time_series, metric: metric, from: date_range.from, to: date_range.to)
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end
