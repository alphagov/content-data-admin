require 'gds_api/content_data_api'

class MetricsService
  DEFAULT_METRICS = %w[pageviews unique_pageviews number_of_internal_searches satisfaction_score].freeze

  def fetch_aggregated_data(base_path:, date_range:)
    url = api.request_url(base_path: base_path, from: date_range.from, to: date_range.to, metrics: DEFAULT_METRICS)
    api.client.get_json(url).to_hash
  end

  def fetch_time_series(base_path:, date_range:)
    url = api.time_series_request_url(base_path: base_path, from: date_range.from, to: date_range.to, metrics: DEFAULT_METRICS)
    api.client.get_json(url).to_hash
  end

  def content_summary(date_range:, organisation:)
    api_with_long_timeout.content_summary(from: date_range.from, to: date_range.to, organisation: organisation)
  end

private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end

  def api_with_long_timeout
    api.tap do |client|
      client.options[:timeout] = 30
    end
  end
end
