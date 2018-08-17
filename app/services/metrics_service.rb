require 'gds_api/base'
class MetricsService
  attr_reader :base_path, :from, :to, :metric

  def fetch(base_path:, from:, to:, metric:)
    url = request_url(base_path, from, to, metric)
    client.get_json(url)
  end

private

  def request_url(base_path, from, to, metric)
    "#{content_data_api_endpoint}/metrics/#{metric}/#{base_path}?from=#{from}&to=#{to}"
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
