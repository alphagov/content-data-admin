require "gds_api/content_data_api"

class SearchController < ApplicationController
  def show
    # Get query string from user
    # Send to search-api
    # For each result query content-data-api using _id of result, which is the path
    # Display results - profit
    search_api ||= GdsApi::Search.new(Plek.find("search"))
    search_results = search_api.search({ q: params[:q] })

    api ||= GdsApi::ContentDataApi.new
    # @results = search_results
    # @results = api.single_page(search_results.first[:id])
    @results = api.single_page(base_path: "/coronavirus", from: "2020-12-01", to: "2021-01-01")
  end
end
