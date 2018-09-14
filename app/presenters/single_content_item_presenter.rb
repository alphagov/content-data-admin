class SingleContentItemPresenter
  attr_reader :unique_pageviews, :unique_pageviews_series,
    :pageviews, :pageviews_series,
    :number_of_internal_searches, :number_of_internal_searches_series,
    :satisfaction_score, :satisfaction_score_series,
    :metadata, :title

  def initialize(from, to)
    @from = from
    @to = to
  end

  def self.parse_metrics(metrics:, from:, to:)
    new(from, to).parse_metrics(metrics.deep_symbolize_keys)
  end

  def parse_metrics(metrics)
    @unique_pageviews = metrics[:unique_pageviews]
    @pageviews = metrics[:pageviews]
    @number_of_internal_searches = metrics[:number_of_internal_searches]
    @satisfaction_score = metrics[:satisfaction_score]
    @title = metrics[:title]
    @metadata = {
      base_path: metrics[:base_path],
      document_type: metrics[:document_type].tr('_', ' ').capitalize,
      published_at: format_date(metrics[:first_published_at]),
      last_updated: format_date(metrics[:public_updated_at]),
      publishing_organisation: metrics[:primary_organisation_title],
    }
    self
  end

  def parse_time_series(time_series)
    @unique_pageviews_series = get_chart_presenter(time_series, :unique_pageviews)
    @pageviews_series = get_chart_presenter(time_series, :pageviews)
    @number_of_internal_searches_series = get_chart_presenter(time_series, :number_of_internal_searches)
    @satisfaction_score_series = get_chart_presenter(time_series, :satisfaction_score)
    self
  end

private

  attr_reader :from, :to

  def get_chart_presenter(time_series, metric)
    ChartPresenter.new(json: time_series, metric: metric, from: from, to: to)
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end
