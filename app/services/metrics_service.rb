require 'gds_api/content_data_api'

class MetricsService
  def fetch(base_path:, from:, to:, metrics:)
    url = api.request_url(base_path: base_path, from: from, to: to, metrics: metrics)
    api.client.get_json(url).to_hash
  end

  def fetch_time_series(base_path:, from:, to:, metrics:)
    url = api.time_series_request_url(base_path: base_path, from: from, to: to, metrics: metrics)
    api.client.get_json(url).to_hash
  end

private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end
end
