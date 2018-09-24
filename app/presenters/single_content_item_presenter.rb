class SingleContentItemPresenter
  include MetricsFormatterHelper

  attr_reader :date_range,
              :metadata,
              :number_of_feedback_comments,
              :number_of_feedback_comments_series,
              :number_of_internal_searches,
              :number_of_internal_searches_series,
              :pageviews,
              :pageviews_series,
              :satisfaction_score,
              :satisfaction_score_series,
              :title,
              :unique_pageviews,
              :unique_pageviews_series

  def initialize(metrics, time_series, date_range)
    @date_range = date_range
    @metrics = metrics
    parse_metrics(metrics.with_indifferent_access)
    parse_time_series(time_series.with_indifferent_access)
  end

  def publishing_app
    publishing_app = @metrics['publishing_app']

    publishing_app.present? ? publishing_app.capitalize : 'Unknown'
  end

private

  def parse_metrics(metrics)
    @unique_pageviews = format_metric_value('unique_pageviews', metrics[:unique_pageviews])
    @pageviews = format_metric_value('pageviews', metrics[:pageviews])
    @number_of_feedback_comments = format_metric_value('feedex_comments', metrics[:feedex_comments])
    @number_of_internal_searches = format_metric_value('number_of_internal_searches', metrics[:number_of_internal_searches])
    @satisfaction_score = format_metric_value('satisfaction_score', metrics[:satisfaction_score])
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
    @unique_pageviews_series = get_chart_presenter(time_series, :unique_pageviews)
    @pageviews_series = get_chart_presenter(time_series, :pageviews)
    @number_of_internal_searches_series = get_chart_presenter(time_series, :number_of_internal_searches)
    @number_of_feedback_comments_series = get_chart_presenter(time_series, :feedex_comments)
    @satisfaction_score_series = get_chart_presenter(time_series, :satisfaction_score)
  end

  def get_chart_presenter(time_series, metric)
    ChartPresenter.new(json: time_series, metric: metric, from: date_range.from, to: date_range.to)
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end
