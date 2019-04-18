require 'gds_api/base'

class GdsApi::ContentDataApi < GdsApi::Base
  def initialize
    super("#{Plek.current.find('content-performance-manager')}/api/v1",
      disable_cache: true,
      bearer_token: ENV['CONTENT_DATA_API_BEARER_TOKEN'] || 'example')
  end

  def aggregated_metrics(base_path:, from:, to:)
    url = aggregated_metrics_url(base_path, from, to)
    get_json(url).to_hash.deep_symbolize_keys
  end

  def time_series(base_path:, from:, to:)
    url = time_series_request_url(base_path, from, to)
    get_json(url).to_hash.deep_symbolize_keys
  end

  def content(date_range:, organisation_id:, document_type: nil, page: nil, page_size: nil, search_term: nil, sort: nil)
    url = content_items_url(date_range, organisation_id, document_type, page, page_size, search_term, sort)
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

  def aggregated_metrics_url(base_path, from, to)
    "#{content_data_api_endpoint}/api/v1/metrics/#{base_path}#{query_string(from: from, to: to)}"
  end

  def time_series_request_url(base_path, from, to)
    "#{content_data_api_endpoint}/api/v1/metrics/#{base_path}/time-series#{query_string(from: from, to: to)}"
  end

  def content_items_url(date_range, organisation_id, document_type, page, page_size, search_term, sort)
    params = {
      date_range: date_range,
      organisation_id: organisation_id,
      document_type: document_type,
      search_term: search_term,
      page: page,
      page_size: page_size,
      sort: sort
    }
    params.reject! { |_, v| v.blank? }

    "#{content_data_api_endpoint}/content#{query_string(params)}"
  end

  def single_page_url(base_path, from, to)
    "#{content_data_api_endpoint}/single_page/#{base_path}#{query_string(from: from, to: to)}"
  end

  def organisations_url
    "#{content_data_api_endpoint}/api/v1/organisations"
  end

  def document_types_url
    "#{content_data_api_endpoint}/api/v1/document_types"
  end
end
