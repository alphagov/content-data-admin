class SingleContentItemPresenter
  include MetricsFormatterHelper

  attr_reader :date_range,
              :metadata,
              :feedex,
              :feedex_series,
              :searches,
              :searches_series,
              :pviews,
              :pviews_series,
              :satisfaction,
              :satisfaction_series,
              :title,
              :upviews,
              :upviews_series,
              :number_of_pdfs,
              :word_count

  def initialize(metrics, time_series, date_range)
    @date_range = date_range
    @metrics = metrics
    parse_metrics(metrics.with_indifferent_access)
    parse_time_series(time_series.with_indifferent_access)
    add_glance_metric_presenters
  end

  def publishing_app
    publishing_app = @metrics['publishing_app']

    publishing_app.present? ? publishing_app.capitalize.tr('-', ' ') : 'Unknown'
  end

private

  def parse_metrics(metrics)
    @upviews = format_metric_value('upviews', metrics[:upviews])
    @pviews = format_metric_value('pviews', metrics[:pviews])
    @feedex = format_metric_value('feedex', metrics[:feedex])
    @searches = format_metric_value('searches', metrics[:searches])
    @number_of_pdfs = format_metric_value('number_of_pdfs', metrics[:number_of_pdfs])
    @word_count = format_metric_value('word_count', metrics[:word_count])
    @satisfaction = format_metric_headline_figure('satisfaction', metrics[:satisfaction])
    @title = metrics[:title]
    @metadata = {
      base_path: metrics[:base_path],
      document_type: metrics[:document_type].tr('_', ' ').capitalize,
      published_at: format_date(metrics[:first_published_at]),
      last_updated: format_date(metrics[:public_updated_at]),
      publishing_organisation: metrics[:primary_organisation_title],
    }
  end

  def parse_time_series(time_series)
    @upviews_series = get_chart_presenter(time_series, :upviews)
    @pviews_series = get_chart_presenter(time_series, :pviews)
    @searches_series = get_chart_presenter(time_series, :searches)
    @feedex_series = get_chart_presenter(time_series, :feedex)
    @satisfaction_series = get_chart_presenter(time_series, :satisfaction)
  end

  def add_glance_metric_presenters
    time_period = @date_range.time_period
    @upviews_glance_metric = GlanceMetricPresenter.new('upviews', @upviews, time_period)
    @satisfaction_glance_metric = GlanceMetricPresenter.new('satisfaction', @satisfaction, time_period)
    @searches_glance_metric = GlanceMetricPresenter.new('searches', @searches, time_period)
    @feedex_glance_metric = GlanceMetricPresenter.new('feedex', @feedex, time_period)
  end

  def get_chart_presenter(time_series, metric)
    ChartPresenter.new(json: time_series, metric: metric, from: date_range.from, to: date_range.to)
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end
