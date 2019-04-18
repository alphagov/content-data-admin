require 'gds_api/content_data_api'
require 'support/response_helpers'

module GdsApi
  module TestHelpers
    module ContentDataApi
      include ResponseHelpers

      CONTENT_DATA_API_ENDPOINT = Plek.current.find('content-data-api')

      def content_data_api_has_orgs
        url = "#{CONTENT_DATA_API_ENDPOINT}/api/v1/organisations"
        body = organisations.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_has_document_types
        url = "#{CONTENT_DATA_API_ENDPOINT}/api/v1/document_types"
        body = document_types.to_json
        stub_request(:get, url).to_return(status: 200, body: body)
      end

      def content_data_api_does_not_have_base_path(base_path:, from:, to:)
        url = "#{CONTENT_DATA_API_ENDPOINT}/single_page/#{base_path}"
        stub_request(:get, url)
          .with(query: { from: from, to: to })
          .to_return(status: 404, body: { some: 'error' }.to_json)
      end

      def content_data_api_has_single_page(base_path:, from:, to:, payload: nil, publishing_app: 'whitehall')
        url = "#{CONTENT_DATA_API_ENDPOINT}/single_page/#{base_path}"
        body = payload || single_page_response(base_path, from, to, publishing_app)
        stub_request(:get, url)
          .with(query: { from: from, to: to })
          .to_return(status: 200, body: body.to_json)
      end

      def content_data_api_has_content_items(date_range:, organisation_id:, document_type: nil, search_term: nil, items:, page_size: nil, sort: nil)
        params = {
          date_range: date_range,
          organisation_id: organisation_id,
          document_type: document_type,
          search_term: search_term,
          page_size: page_size,
          sort: sort
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
    end
  end
end
