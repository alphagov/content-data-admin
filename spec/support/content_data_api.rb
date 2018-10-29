require 'gds_api/content_data_api'

module GdsApi
  module TestHelpers
    module ContentDataApi
      def stub_metrics_page(base_path:, time_period:)
        dates = build(:date_range, time_period)
        prev_dates = dates.previous

        current_period_data = default_single_page_payload(
          base_path, dates.from, dates.to
        )
        previous_period_data = default_previous_single_page_payload(
          base_path, prev_dates.from, prev_dates.to
        )

        content_data_api_has_single_page(
          base_path: base_path,
          from: dates.from,
          to: dates.to,
          payload: current_period_data
        )
        content_data_api_has_single_page(
          base_path: base_path,
          from: prev_dates.from,
          to: prev_dates.to,
          payload: previous_period_data
        )
      end

      def content_data_api_does_not_have_base_path(base_path:, from:, to:)
        query = query(from: from, to: to)
        url = "#{content_data_api_endpoint}/single_page/#{base_path}#{query}"
        stub_request(:get, url).to_return(status: 404, body: { some: 'error' }.to_json)
      end

      def content_data_api_has_content_items(from:, to:, organisation_id:, document_type: nil, items:)
        params = {
          from: from,
          to: to,
          organisation_id: organisation_id,
          document_type: document_type
        }.reject { |_, v| v.blank? }
        query = query(params)
        url = "#{content_data_api_endpoint}/content#{query}"
        body = { results: items }.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_has_single_page(base_path:, from:, to:, payload: nil)
        query = query(from: from, to: to)
        url = "#{content_data_api_endpoint}/single_page/#{base_path}#{query}"
        body = payload || default_single_page_payload(base_path, from, to)
        stub_request(:get, url).to_return(status: 200, body: body.to_json)
      end

      def content_data_api_has_single_page_missing_data(base_path:, from:, to:)
        query = query(from: from, to: to)
        url = "#{content_data_api_endpoint}/single_page/#{base_path}#{query}"
        body = no_data_single_page_payload(base_path, from, to).to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_has_orgs
        url = "#{content_data_api_endpoint}/organisations"
        body = { organisations: default_organisations }.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_has_document_types
        url = "#{content_data_api_endpoint}/document_types"
        body = { document_types: default_document_types }.to_json
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
        day1 = from
        day2 = (Date.parse(from) + 1.day).to_s
        day3 = to
        {
          metadata: {
            title:  "Content Title",
            base_path:  "/#{base_path}",
            content_id: 'content-id',
            first_published_at:  "2018-07-17T10:35:59.000Z",
            public_updated_at:  "2018-07-17T10:35:57.000Z",
            publishing_app:  "whitehall",
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
              total: 6000,
              time_series: [
                { "date" => day1, "value" => 1000 },
                { "date" => day2, "value" => 2000 },
                { "date" => day3, "value" => 3000 }
              ]
            },
            {
              name: "pviews",
              total: 60000,
              time_series: [
                { "date" => day1, "value" => 10000 },
                { "date" => day2, "value" => 20000 },
                { "date" => day3, "value" => 30000 }
              ]
            },
            {
              name: "searches",
              total: 243,
              time_series: [
                { "date" => day1, "value" => 80 },
                { "date" => day2, "value" => 80 },
                { "date" => day3, "value" => 83 }
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

      def default_previous_single_page_payload(base_path, from, to)
        day1 = from
        day2 = (Date.parse(from) + 1.day).to_s
        day3 = to
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
              total: 1000,
              time_series: [
                { "date" => day1, "value" => 1000 },
                { "date" => day2, "value" => 2000 },
                { "date" => day3, "value" => 7000 }
              ]
            },
            {
              name: "pviews",
              total: 30000,
              time_series: [
                { "date" => day1, "value" => 5 },
                { "date" => day2, "value" => 5 },
                { "date" => day3, "value" => 20 }
              ]
            },
            {
              name: "searches",
              total: 48,
              time_series: [
                { "date" => day1, "value" => 16 },
                { "date" => day2, "value" => 16 },
                { "date" => day3, "value" => 16 }
              ]
            },
            {
              name: "feedex",
              total: 60,
              time_series: [
                { "date" => day1, "value" => 20 },
                { "date" => day2, "value" => 20 },
                { "date" => day3, "value" => 20 }
              ]
            },
            {
              name: "satisfaction",
              total: 0.6,
              time_series: [
                { "date" => day1, "value" => 0.6000 },
                { "date" => day2, "value" => 0.6000 },
                { "date" => day3, "value" => 0.6000 }
              ]
            },
            {
              "name": "useful_yes",
              "total": 600,
              "time_series": []
            },
            {
              "name": "useful_no",
              "total": 400,
              "time_series": []
            }
          ],
          edition_metrics: [
            {
              name: "words",
              value: 300
            },
            {
              name: "pdf_count",
              value: 5
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

      def default_document_types
        %w[case_study guide news_story]
      end
    end
  end
end
