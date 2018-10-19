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

  def content(from:, to:, organisation_id:, document_type: nil)
    url = content_items_url(from, to, organisation_id, document_type)
    get_json(url).to_hash.deep_symbolize_keys
  end

  def single_page(base_path:, from:, to:)
    url = single_page_url(base_path, from, to)
    get_json(url).to_hash.deep_symbolize_keys
  end

  def organisations
    get_json(organisations_url).to_hash.deep_symbolize_keys
  end

  def document_types
    get_json(document_types_url).to_hash.deep_symbolize_keys
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

  def content_items_url(from, to, organisation_id, document_type)
    params = {
      from: from,
      to: to,
      organisation_id: organisation_id,
      document_type: document_type
 }.reject { |_, v| v.blank? }
    "#{content_data_api_endpoint}/content#{query_string(params)}"
  end

  def single_page_url(base_path, from, to)
    "#{content_data_api_endpoint}/single_page/#{base_path}#{query_string(from: from, to: to)}"
  end

  def organisations_url
    "#{content_data_api_endpoint}/organisations"
  end

  def document_types_url
    "#{content_data_api_endpoint}/document_types"
  end
end
