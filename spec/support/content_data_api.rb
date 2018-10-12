require 'gds_api/content_data_api'

module GdsApi
  module TestHelpers
    module ContentDataApi
      def content_data_api_does_not_have_base_path(base_path:, from:, to:)
        query = query(from: from, to: to)
        url = "#{content_data_api_endpoint}/single_page/#{base_path}#{query}"
        stub_request(:get, url).to_return(status: 404, body: { some: 'error' }.to_json)
      end

      def content_data_api_has_content_items(from:, to:, organisation_id:, items:)
        query = query(from: from, to: to, organisation_id: organisation_id)
        url = "#{content_data_api_endpoint}/content#{query}"
        body = { results: items }.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_has_single_page(base_path:, from:, to:)
        query = query(from: from, to: to)
        url = "#{content_data_api_endpoint}/single_page/#{base_path}#{query}"
        body = default_single_page_payload(base_path, from, to).to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_has_single_page_missing_data(base_path:, from:, to:)
        query = query(from: from, to: to)
        url = "#{content_data_api_endpoint}/single_page/#{base_path}#{query}"
        body = no_data_single_page_payload(base_path, from, to).to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_has_orgs
        url = "#{content_data_api_endpoint}/organisations"
        body = { organisations: default_organisations }.to_json
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

      def default_single_page_payload(base_path, from, to)
        from_date = Date.parse(from)
        to_date = Date.parse(to)
        day1 = (from_date - 1.day).to_s
        day2 = (from_date - 2.days).to_s
        day3 = (to_date + 1.day).to_s
        {
          metadata: {
            title:  "Content Title",
            base_path:  "/#{base_path}",
            first_published_at:  "2018-07-17T10:35:59.000Z",
            public_updated_at:  "2018-07-17T10:35:57.000Z",
            publishing_app:  "publisher",
            document_type:  "news_story",
            primary_organisation_title:  "The Ministry"
          },
          time_period: {
            to: to,
            from: from
          },
          time_series_metrics: [
            {
              name: "upviews",
              total: 33,
              time_series: [
                { "date" => day1, "value" => 1 },
                { "date" => day2, "value" => 2 },
                { "date" => day3, "value" => 30 }
              ]
            },
            {
              name: "pviews",
              total: 60,
              time_series: [
                { "date" => day1, "value" => 10 },
                { "date" => day2, "value" => 20 },
                { "date" => day3, "value" => 30 }
              ]
            },
            {
              name: "searches",
              total: 24,
              time_series: [
                { "date" => day1, "value" => 8 },
                { "date" => day2, "value" => 8 },
                { "date" => day3, "value" => 8 }
              ]
            },
            {
              name: "feedex",
              total: 63,
              time_series: [
                { "date" => day1, "value" => 20 },
                { "date" => day2, "value" => 21 },
                { "date" => day3, "value" => 22 }
              ]
            },
            {
              name: "satisfaction",
              total: 0.9,
              time_series: [
                { "date" => day1, "value" => 1.0000 },
                { "date" => day2, "value" => 0.9000 },
                { "date" => day3, "value" => 0.80000 }
              ]
            },
            {
              "name": "useful_yes",
              "total": 200,
              "time_series": []
            },
            {
              "name": "useful_no",
              "total": 500,
              "time_series": []
            }
          ],
          edition_metrics: [
            {
              name: "words",
              value: 200
            },
            {
              name: "pdf_count",
              value: 3
            }
          ]
        }
      end

      def no_data_single_page_payload(base_path, from, to)
        {
          metadata: {
            title:  "Content Title",
            base_path:  "/#{base_path}",
            first_published_at:  "2018-07-17T10:35:59.000Z",
            public_updated_at:  "2018-07-17T10:35:57.000Z",
            publishing_app:  "publisher",
            document_type:  "news_story",
            primary_organisation_title:  "The Ministry"
          },
          time_period: { to: to, from: from },
          time_series_metrics: [
            { name: "upviews", total: 0, time_series: [] },
            { name: "pviews", total: 0, time_series: [] },
            { name: "searches", total: 0, time_series: [] },
            { name: "feedex", total: 0, time_series: [] },
            { name: "satisfaction", total: 0.0, time_series: [] },
            { name: "useful_yes", total: 0, time_series: [] },
            { name: "useful_no", total: 0, time_series: [] }
          ],
          edition_metrics: [
            { name: "words", value: 0 },
            { name: "pdf_count", value: 0 }
          ]
        }
      end

      def default_organisations
        [
          {
            title: 'org',
            organisation_id: 'org-id'
          },
          {
            title: 'another org',
            organisation_id: 'another-org-id'
          }
        ]
      end
    end
  end
end
