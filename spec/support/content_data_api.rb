require 'gds_api/content_data_api'

module GdsApi
  module TestHelpers
    module ContentDataApi
      def content_data_api_has_metric(base_path:, from:, to:, metrics:)
        query = query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/api/v1/metrics/#{base_path}#{query}"
        body = default_metric_payload(base_path)
        stub_request(:get, url).to_return(status: 200, body: body.to_json)
      end

      def content_data_api_does_not_have_base_path(base_path:, from:, to:, metrics:)
        query = query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/api/v1/metrics/#{base_path}#{query}"
        stub_request(:get, url).to_return(status: 404, body: { some: 'error' }.to_json)
      end

      def content_data_api_has_timeseries(base_path:, from:, to:, metrics:, payload: nil)
        query = query(from: from, to: to, metrics: metrics)
        url = "#{content_data_api_endpoint}/api/v1/metrics/#{base_path}/time-series#{query}"
        body = payload.nil? ? default_timeseries_payload(from.to_date, to.to_date) : payload
        stub_request(:get, url).to_return(status: 200, body: body.to_json)
      end

      def content_data_api_has_content_items(from:, to:, organisation_id:, items:)
        query = query(from: from, to: to, organisation_id: organisation_id)
        url = "#{content_data_api_endpoint}/content#{query}"
        body = { results: items }.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_endpoint
        Plek.current.find('content-performance-manager').to_s
      end

      def query(params)
        param_pairs = params.sort.map { |key, value|
          case value
          when Array
            value.map { |v|
              "#{CGI.escape(key.to_s + '[]')}=#{CGI.escape(v.to_s)}"
            }
          else
            "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
          end
        }.flatten

        "?#{param_pairs.join('&')}"
      end

      def default_metric_payload(base_path)
        {
          base_path: "/#{base_path}",
          upviews: 145_000,
          pviews: 200_000,
          satisfaction_score: 25.55,
          searches: 250,
          feedex_comments: 20,
          number_of_pdfs: 3,
          word_count: 200,
          title: "Content Title",
          first_published_at: '2018-02-01T00:00:00.000Z',
          public_updated_at: '2018-04-25T00:00:00.000Z',
          primary_organisation_title: 'The ministry',
          document_type: "news_story",
          publishing_app: 'whitehall',
        }
      end

      def default_timeseries_payload(from, to)
        {
          upviews: [
            { "date" => (from - 1.day).to_s, "value" => 1 },
            { "date" => (from - 2.days).to_s, "value" => 2 },
            { "date" => (to + 1.day).to_s, "value" => 30 }
          ],
          pviews: [
            { "date" => (from - 1.day).to_s, "value" => 10 },
            { "date" => (from - 2.days).to_s, "value" => 20 },
            { "date" => (to + 1.day).to_s, "value" => 30 }
          ],
          searches: [
            { "date" => (from - 1.day).to_s, "value" => 8 },
            { "date" => (from - 2.days).to_s, "value" => 8 },
            { "date" => (to + 1.day).to_s, "value" => 8 }
          ],
          feedex_comments: [
            { "date" => (from - 1.day).to_s, "value" => 20 },
            { "date" => (from - 2.days).to_s, "value" => 21 },
            { "date" => (to + 1.day).to_s, "value" => 22 }
          ],
          satisfaction_score: [
            { "date" => (from - 1.day).to_s, "value" => 1.0000 },
            { "date" => (from - 2.days).to_s, "value" => 0.9000 },
            { "date" => (to + 1.day).to_s, "value" => 0.80000 }
          ],
          word_count: [
            { "date" => (from - 1.day).to_s, "value" => 200 },
            { "date" => (from - 2.days).to_s, "value" => 200 },
            { "date" => (to + 1.day).to_s, "value" => 200 }
          ],
          number_of_pdfs: [
            { "date" => (from - 1.day).to_s, "value" => 3 },
            { "date" => (from - 2.days).to_s, "value" => 3 },
            { "date" => (to + 1.day).to_s, "value" => 3 }
          ]
        }
      end
    end
  end
end
