require 'gds_api/content_data_api'

class MetricsService
  DEFAULT_METRICS = %w[pageviews unique_pageviews number_of_internal_searches satisfaction_score].freeze

  def fetch_aggregated_data(base_path:, date_range:)
    api.aggregated_metrics(base_path: base_path, from: date_range.from, to: date_range.to, metrics: DEFAULT_METRICS)
  end

  def fetch_time_series(base_path:, date_range:)
    api.time_series(base_path: base_path, from: date_range.from, to: date_range.to, metrics: DEFAULT_METRICS)
  end

private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end
end
