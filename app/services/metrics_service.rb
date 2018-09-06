require 'gds_api/base'
class MetricsService
  attr_reader :base_path, :from, :to, :metric

  def fetch(base_path:, from:, to:, metrics:)
    url = request_url(base_path, from, to, metrics)
    client.get_json(url)
  end

  def fetch_timeseries(base_path:, from:, to:, metric:)
    url = time_series_request_url(base_path, from, to, metric)
    client.get_json(url).to_hash
  end

private

  def request_url(base_path, from, to, metrics)
    metrics_query_string = metrics.map { |metric| "metrics[]=#{metric}" }.join('&')
    "#{content_data_api_endpoint}/metrics/#{base_path}?from=#{from}&to=#{to}&#{metrics_query_string}"
  end

  def time_series_request_url(base_path, from, to, metric)
    "#{content_data_api_endpoint}/metrics/#{metric}/#{base_path}/time-series?from=#{from}&to=#{to}"
  end

  def content_data_api_endpoint
    "#{Plek.current.find('content-performance-manager')}/api/v1"
  end

  def client
    @client ||= GdsApi::Base.new(content_data_api_endpoint,
                                 disable_cache: true,
                                 bearer_token: ENV['CONTENT_PERFORMANCE_MANAGER_BEARER_TOKEN'] || 'example').client
  end
end
