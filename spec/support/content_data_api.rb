module GdsApi
  module TestHelpers
    module ContentDataApi
      def content_api_has_metric(base_path, metric, from, to, payload)
        url = "#{content_data_api_endpoint}/metrics/#{metric}/#{base_path}?from=#{from}&to=#{to}"
        body = payload.to_json
        stub_request(:get, url).to_return(
          status: 200,
          body: body
        )
      end

      def content_data_api_endpoint
        "#{Plek.current.find('content-performance-manager')}/api/v1"
      end
    end
  end
end
