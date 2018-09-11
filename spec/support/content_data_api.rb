require 'gds_api/content_data_api'

module GdsApi
  module TestHelpers
    module ContentDataApi
      def content_data_api_has_metric(base_path:, from:, to:, metrics:, payload:)
        query = GdsApi::ContentDataApi.new.query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/metrics/#{base_path}#{query}"
        body = payload.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_does_not_have_base_path(base_path:, from:, to:, metrics:)
        query = GdsApi::ContentDataApi.new.query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/metrics/#{base_path}#{query}"
        stub_request(:get, url).to_return(status: 404, body: { some: 'error' }.to_json)
      end

      def content_data_api_has_timeseries(base_path:, from:, to:, metrics:, payload:)
        query = GdsApi::ContentDataApi.new.query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/metrics/#{base_path}/time-series#{query}"
        body = payload.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_endpoint
        "#{Plek.current.find('content-performance-manager')}/api/v1"
      end
    end
  end
end
