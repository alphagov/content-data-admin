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

  def query(from:, to:, metrics:)
    query_params = {}
    query_params[:from] = from
    query_params[:to] = to
    query_params[:metrics] = metrics

    query_string(query_params)
  end
end
