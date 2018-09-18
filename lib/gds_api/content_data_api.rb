require 'gds_api/base'

class GdsApi::ContentDataApi < GdsApi::Base
  def initialize
    super("#{Plek.current.find('content-performance-manager')}/api/v1",
        disable_cache: true,
        bearer_token: ENV['CONTENT_PERFORMANCE_MANAGER_BEARER_TOKEN'] || 'example')
  end

  def request_url(base_path:, from:, to:, metrics:)
    "#{content_data_api_endpoint}/metrics/#{base_path}#{query(from: from, to: to, metrics: metrics)}"
  end

  def time_series_request_url(base_path:, from:, to:, metrics:)
    "#{content_data_api_endpoint}/metrics/#{base_path}/time-series#{query(from: from, to: to, metrics: metrics)}"
  end

  def content_data_api_endpoint
    "#{Plek.current.find('content-performance-manager')}/api/v1"
  end

  def content_summary(from:, to:, organisation:)
    url = content_items_url(from, to, organisation)
    get_json(url).to_hash
  end

  def query(query_params)
    query_string(query_params)
  end

private

  def content_items_url(from, to, organisation)
    "#{content_data_api_endpoint}/content#{query(from: from, to: to, organisation: organisation)}"
  end
end
