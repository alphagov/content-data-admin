require 'gds_api/base'

class GdsApi::ContentDataApi < GdsApi::Base
  def initialize
    super("#{Plek.current.find('content-performance-manager')}/api/v1",
      disable_cache: true,
      bearer_token: ENV['CONTENT_PERFORMANCE_MANAGER_BEARER_TOKEN'] || 'example')
  end

  def aggregated_metrics(base_path:, from:, to:, metrics:)
    url = aggregated_metrics_url(base_path, from, to, metrics)
    get_json(url).to_hash.deep_symbolize_keys
  end

  def time_series(base_path:, from:, to:, metrics:)
    url = time_series_request_url(base_path, from, to, metrics)
    get_json(url).to_hash.deep_symbolize_keys
  end

  def content(from:, to:, organisation_id:)
    url = content_items_url(from, to, organisation_id)
    get_json(url).to_hash.deep_symbolize_keys
  end

  def single_page(base_path:, from:, to:)
    url = single_page_url(base_path, from, to)
    get_json(url).to_hash.deep_symbolize_keys
  end

private

  def content_data_api_endpoint
    Plek.current.find('content-performance-manager').to_s
  end

  def aggregated_metrics_url(base_path, from, to, metrics)
    "#{content_data_api_endpoint}/api/v1/metrics/#{base_path}#{query_string(from: from, to: to, metrics: metrics)}"
  end

  def time_series_request_url(base_path, from, to, metrics)
    "#{content_data_api_endpoint}/api/v1/metrics/#{base_path}/time-series#{query_string(from: from, to: to, metrics: metrics)}"
  end

  def content_items_url(from, to, organisation_id)
    "#{content_data_api_endpoint}/content#{query_string(from: from, to: to, organisation_id: organisation_id)}"
  end

  def single_page_url(base_path, from, to)
    "#{content_data_api_endpoint}/single_page/#{base_path}#{query_string(from: from, to: to)}"
  end
end
