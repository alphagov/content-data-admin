require "gds_api/content_data_api"

module GdsApi
  module TestHelpers
    module ResponseHelpers
      def content_response
        {
          total_results: 3,
          page: 1,
          total_pages: 1,
          page_size: 100,
          results: [
            {
              base_path: "/",
              title: "GOV.UK homepage",
              organisation_id: "org-id",
              upviews: 1_233_018,
              document_type: "homepage",
              satisfaction: 0.85,
              searches: 1220,
              pviews: 8373274,
              feedex: 137,
              useful_yes: 1050,
              useful_no: 2334,
              pdf_count: 0,
              words: 0,
            },
            {
              base_path: "/path/1",
              title: "The title",
              organisation_id: "org-id",
              upviews: 233_018,
              document_type: "news_story",
              satisfaction: 0.81301,
              searches: 220,
              pviews: 179_926,
              feedex: 180,
              useful_yes: 2837,
              useful_no: 7495,
              pdf_count: 0,
              words: 0,
            },
            {
              base_path: "/path/2",
              title: "Another title",
              organisation_id: "org-id",
              upviews: 100_018,
              document_type: "guide",
              satisfaction: 0.68,
              searches: 12,
              pviews: 95_232,
              feedex: 72,
              useful_yes: 1530,
              useful_no: 1255,
              pdf_count: 0,
              words: 170,
            },
          ],
        }
      end

      def document_children_response
        {
          "parent_base_path": "/parent",
          "documents" => [
            {
              "base_path" => "/parent",
              "title" => "Parent",
              "primary_organisation_id" => "7809-org",
              "document_type" => "manual",
              "sibling_order" => 0,
              "upviews" => 10,
              "pviews" => 2,
              "feedex" => 0,
              "useful_yes" => 75,
              "useful_no" => 25,
              "satisfaction" => 0.75,
              "searches" => 3,
            },
            {
              "base_path" => "/child/1",
              "title" => "Child 1",
              "primary_organisation_id" => "7809-org",
              "document_type" => "manual_section",
              "sibling_order" => 1,
              "upviews" => 1000000,
              "pviews" => 2,
              "feedex" => 0,
              "useful_yes" => 75,
              "useful_no" => 25,
              "satisfaction" => 0.75,
              "searches" => 3,
            },
            {
              "base_path" => "/child/2",
              "title" => "Child 2",
              "primary_organisation_id" => "7809-org",
              "document_type" => "manual_section",
              "sibling_order" => 2,
              "upviews" => 0,
              "pviews" => 2,
              "feedex" => 0,
              "useful_yes" => 75,
              "useful_no" => 25,
              "satisfaction" => 0.75,
              "searches" => 3,
            },
          ],
        }
      end

      def single_page_response(base_path, from, to, publishing_app = "whitehall")
        day1 = from.to_s
        day2 = (from + 1.day).to_s
        day3 = to.to_s
        {
          metadata: {
            title: "Content Title",
            base_path: "/#{base_path}",
            content_id: "content-id",
            locale: "fr",
            first_published_at: "2018-07-17T10:35:59.000Z",
            public_updated_at: "2018-07-17T10:35:57.000Z",
            publishing_app: publishing_app,
            document_type: "news_story",
            primary_organisation_title: "The Ministry",
            historical: false,
            withdrawn: false,
            parent_document_id: nil,
          },
          number_of_related_content: 0,
          time_period: {
            to: to,
            from: from,
          },
          time_series_metrics: [
            {
              name: "upviews",
              total: 6000,
              time_series: [
                { "date" => day1, "value" => 1000 },
                { "date" => day2, "value" => 2000 },
                { "date" => day3, "value" => 3000 },
              ],
            },
            {
              name: "pviews",
              total: 60000,
              time_series: [
                { "date" => day1, "value" => 10000 },
                { "date" => day2, "value" => 20000 },
                { "date" => day3, "value" => 30000 },
              ],
            },
            {
              name: "searches",
              total: 243,
              time_series: [
                { "date" => day1, "value" => 80 },
                { "date" => day2, "value" => 80 },
                { "date" => day3, "value" => 83 },
              ],
            },
            {
              name: "feedex",
              total: 63,
              time_series: [
                { "date" => day1, "value" => 20 },
                { "date" => day2, "value" => 21 },
                { "date" => day3, "value" => 22 },
              ],
            },
            {
              name: "satisfaction",
              total: 0.9,
              time_series: [
                { "date" => day1, "value" => 1.0000 },
                { "date" => day2, "value" => 0.9000 },
                { "date" => day3, "value" => 0.80000 },
              ],
            },
            {
              "name": "useful_yes",
              "total": 200,
              "time_series": [],
            },
            {
              "name": "useful_no",
              "total": 500,
              "time_series": [],
            },
          ],
          edition_metrics: [
            {
              name: "words",
              value: 200,
            },
            {
              name: "pdf_count",
              value: 3,
            },
            {
              name: "reading_time",
              value: 20,
            },
          ],
        }
      end

      def older_single_page_response(base_path, from, to)
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
            withdrawn: false,
          },
          time_period: {
            to: to,
            from: from,
          },
          time_series_metrics: [
            {
              name: "upviews",
              total: 1000,
              time_series: [
                { "date" => day1, "value" => 1000 },
                { "date" => day2, "value" => 2000 },
                { "date" => day3, "value" => 7000 },
              ],
            },
            {
              name: "pviews",
              total: 30000,
              time_series: [
                { "date" => day1, "value" => 5 },
                { "date" => day2, "value" => 5 },
                { "date" => day3, "value" => 20 },
              ],
            },
            {
              name: "searches",
              total: 6,
              time_series: [
                { "date" => day1, "value" => 2 },
                { "date" => day2, "value" => 2 },
                { "date" => day3, "value" => 2 },
              ],
            },
            {
              name: "feedex",
              total: 60,
              time_series: [
                { "date" => day1, "value" => 20 },
                { "date" => day2, "value" => 20 },
                { "date" => day3, "value" => 20 },
              ],
            },
            {
              name: "satisfaction",
              total: 0.6,
              time_series: [
                { "date" => day1, "value" => 0.6000 },
                { "date" => day2, "value" => 0.6000 },
                { "date" => day3, "value" => 0.6000 },
              ],
            },
            {
              "name": "useful_yes",
              "total": 600,
              "time_series": [],
            },
            {
              "name": "useful_no",
              "total": 400,
              "time_series": [],
            },
          ],
          edition_metrics: [
            {
              name: "words",
              value: 300,
            },
            {
              name: "pdf_count",
              value: 5,
            },
            {
              name: "reading_time",
              value: 20,
            },
          ],
        }
      end

      def organisations
        {
          organisations: [
            {
              name: "org",
              id: "org-id",
              acronym: "OI",
            },
            {
              name: "another org",
              id: "another-org-id",
            },
            {
              name: "Users Org",
              id: "users-org-id",
              acronym: "UOI",
            },
          ],
        }
      end

      def document_types
        {
          document_types: [
            {
              id: "case_study",
              name: "Case study",
            },
            {
              id: "guide",
              name: "Guide",
            },
            {
              id: "news_story",
              name: "News story",
            },
            {
              id: "html_publication",
              name: "HTML publication",
            },
          ],
        }
      end
    end
  end
end
