require 'gds_api/content_data_api'

module GdsApi
  module TestHelpers
    module ContentDataApi
      CONTENT_DATA_API_ENDPOINT = Plek.current.find('content-performance-manager')

      def content_data_api_has_orgs
        url = "#{CONTENT_DATA_API_ENDPOINT}/api/v1/organisations"
        body = { organisations: default_organisations }.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_has_document_types
        url = "#{CONTENT_DATA_API_ENDPOINT}/api/v1/document_types"
        body = { document_types: default_document_types }.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_does_not_have_base_path(base_path:, from:, to:)
        url = "#{CONTENT_DATA_API_ENDPOINT}/single_page/#{base_path}"
        stub_request(:get, url)
          .with(query: { from: from, to: to })
          .to_return(status: 404, body: { some: 'error' }.to_json)
      end

      def content_data_api_has_content_items(date_range:, organisation_id:, document_type: nil, search_term: nil, items:, page_size: nil)
        params = {
          date_range: date_range,
          organisation_id: organisation_id,
          document_type: document_type,
          search_term: search_term,
          page_size: page_size,
        }.reject { |_, v| v.blank? }

        url = "#{CONTENT_DATA_API_ENDPOINT}/content"

        if items.empty?
          stub_request(:get, url).with(query: params).to_return(
            status: 200,
            body: { results: [], total_results: 0, total_pages: 0, page: 1 }.to_json
          )
        else
          page_size ||= 100
          total_pages = (items.length.to_f / page_size).ceil

          items.each_slice(page_size).with_index(1) do |(*items_for_page), page|
            body = {
              results: items_for_page,
              total_results: items.length,
              total_pages: total_pages,
              page: page
            }.to_json


            if page == 1
              # In addition, the 1st page can be requested without specifying a page number
              stub_request(:get, url)
                .with(query: params)
                .to_return(status: 200, body: body)
            end

            stub_request(:get, url)
              .with(query: params.merge(page: page))
              .to_return(status: 200, body: body)
          end
        end
      end

      def content_data_api_has_single_page(base_path:, from:, to:, payload: nil, publishing_app: 'whitehall')
        url = "#{CONTENT_DATA_API_ENDPOINT}/single_page/#{base_path}"
        body = payload || default_single_page_payload(base_path, from, to, publishing_app)
        stub_request(:get, url)
          .with(query: { from: from, to: to })
          .to_return(status: 200, body: body.to_json)
      end

      def content_data_api_has_single_page_missing_data(base_path:, from:, to:)
        url = "#{CONTENT_DATA_API_ENDPOINT}/single_page/#{base_path}"
        body = no_data_single_page_payload(base_path, from, to).to_json
        stub_request(:get, url)
          .with(query: { from: from, to: to })
          .to_return(status: 200, body: body)
      end

      def content_data_api_has_single_page_with_nil_values(base_path:, from:, to:)
        url = "#{CONTENT_DATA_API_ENDPOINT}/single_page/#{base_path}"
        body = nil_values_in_single_page_payload(base_path, from, to).to_json
        stub_request(:get, url)
          .with(query: { from: from, to: to })
          .to_return(status: 200, body: body)
      end

      def default_single_page_payload(base_path, from, to, publishing_app = 'whitehall')
        day1 = from.to_s
        day2 = (from + 1.day).to_s
        day3 = to.to_s
        {
          metadata: {
            title: "Content Title",
            base_path: "/#{base_path}",
            content_id: 'content-id',
            first_published_at: "2018-07-17T10:35:59.000Z",
            public_updated_at: "2018-07-17T10:35:57.000Z",
            publishing_app: publishing_app,
            document_type: "news_story",
            primary_organisation_title: "The Ministry",
            historical: false,
            withdrawn: false,
            parent_content_id: ''
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
        day1 = from.to_s
        day2 = (from + 1.day).to_s
        day3 = to.to_s
        {
          metadata: {
            title: "Content Title",
            base_path: "/#{base_path}",
            first_published_at: "2018-07-17T10:35:59.000Z",
            public_updated_at: "2018-07-17T10:35:57.000Z",
            publishing_app: "publisher",
            document_type: "news_story",
            primary_organisation_title: "The Ministry",
            historical: false,
            withdrawn: false
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
            title: "Content Title",
            base_path: "/#{base_path}",
            first_published_at: "2018-07-17T10:35:59.000Z",
            public_updated_at: "2018-07-17T10:35:57.000Z",
            publishing_app: "publisher",
            document_type: "news_story",
            primary_organisation_title: "The Ministry",
            historical: false,
            withdrawn: false
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

      def nil_values_in_single_page_payload(base_path, from, to)
        {
          metadata: {
            title: "Content Title",
            base_path: "/#{base_path}",
            first_published_at: "2018-07-17T10:35:59.000Z",
            public_updated_at: "2018-07-17T10:35:57.000Z",
            publishing_app: "publisher",
            document_type: "news_story",
            primary_organisation_title: "The Ministry",
            historical: false,
            withdrawn: false
          },
          time_period: { to: to, from: from },
          time_series_metrics: [
            { name: "upviews", total: nil, time_series: [] },
            { name: "pviews", total: nil, time_series: [] },
            { name: "searches", total: nil, time_series: [] },
            { name: "feedex", total: nil, time_series: [] },
            { name: "satisfaction", total: nil, time_series: [] },
            { name: "useful_yes", total: nil, time_series: [] },
            { name: "useful_no", total: nil, time_series: [] }
          ],
          edition_metrics: [
            { name: "words", value: nil },
            { name: "pdf_count", value: nil }
          ]
        }
      end

      def default_organisations
        [
          {
            name: 'org',
            id: 'org-id',
            acronym: 'OI',
          },
          {
            name: 'another org',
            id: 'another-org-id',
          },
          {
            name: 'Users Org',
            id: 'users-org-id',
            acronym: 'UOI',
          }
        ]
      end

      def default_document_types
        [
          {
            id: 'case_study',
            name: 'Case study'
          },
          {
            id: 'guide',
            name: 'Guide'
          },
          {
            id: 'news_story',
            name: 'News story'
          },
          {
            id: 'html_publication',
            name: 'HTML publication'
          }
        ]
      end
    end
  end
end
