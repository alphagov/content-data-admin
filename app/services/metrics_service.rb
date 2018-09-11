require 'gds_api/content_data_api'

class MetricsService
  DEFAULT_METRICS = %w[pageviews unique_pageviews number_of_internal_searches satisfaction_score].freeze
  def fetch(base_path:, from:, to:)
    url = api.request_url(base_path: base_path, from: from, to: to, metrics: DEFAULT_METRICS)
    api.client.get_json(url).to_hash
  end

  def fetch_time_series(base_path:, from:, to:)
    url = api.time_series_request_url(base_path: base_path, from: from, to: to, metrics: DEFAULT_METRICS)
    api.client.get_json(url).to_hash
  end

private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end
end
