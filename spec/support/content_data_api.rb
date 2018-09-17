require 'gds_api/content_data_api'

module GdsApi
  module TestHelpers
    module ContentDataApi
      def content_data_api_has_metric(base_path:, from:, to:, metrics:)
        query = GdsApi::ContentDataApi.new.query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/metrics/#{base_path}#{query}"
        body = default_metric_payload(base_path)
        stub_request(:get, url).to_return(status: 200, body: body.to_json)
      end

      def content_data_api_does_not_have_base_path(base_path:, from:, to:, metrics:)
        query = GdsApi::ContentDataApi.new.query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/metrics/#{base_path}#{query}"
        stub_request(:get, url).to_return(status: 404, body: { some: 'error' }.to_json)
      end

      def content_data_api_has_timeseries(base_path:, from:, to:, metrics:, payload: nil)
        query = GdsApi::ContentDataApi.new.query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/metrics/#{base_path}/time-series#{query}"
        body = payload.nil? ? default_timeseries_payload(from.to_date, to.to_date) : payload
        stub_request(:get, url).to_return(status: 200, body: body.to_json)
      end

      def content_data_api_endpoint
        "#{Plek.current.find('content-performance-manager')}/api/v1"
      end

      def default_metric_payload(base_path)
        {
          base_path: "/#{base_path}",
          unique_pageviews: 145_000,
          pageviews: 200_000,
          satisfaction_score: 25.5,
          number_of_internal_searches: 250,
          title: "Content Title",
          first_published_at: '2018-02-01T00:00:00.000Z',
          public_updated_at: '2018-04-25T00:00:00.000Z',
          primary_organisation_title: 'The ministry',
          document_type: "news_story"
        }
      end

      def default_timeseries_payload(from, to)
        {
          unique_pageviews: [
            { "date" => (from - 1.day).to_s, "value" => 1 },
            { "date" => (from - 2.days).to_s, "value" => 2 },
            { "date" => (to + 1.day).to_s, "value" => 30 }
          ],
          pageviews: [
            { "date" => (from - 1.day).to_s, "value" => 10 },
            { "date" => (from - 2.days).to_s, "value" => 20 },
            { "date" => (to + 1.day).to_s, "value" => 30 }
          ],
          number_of_internal_searches: [
            { "date" => (from - 1.day).to_s, "value" => 8 },
            { "date" => (from - 2.days).to_s, "value" => 8 },
            { "date" => (to + 1.day).to_s, "value" => 8 }
          ],
          satisfaction_score: [
            { "date" => (from - 1.day).to_s, "value" => 100 },
            { "date" => (from - 2.days).to_s, "value" => 90 },
            { "date" => (to + 1.day).to_s, "value" => 80 }
          ]
        }
      end
    end
  end
end
