require "active_support/concern"
require "site-improve-api-client"

module SiteImproveApiClient
  extend ActiveSupport::Concern

  included do
    def content_api
        @content_api ||= SiteImproveAPIClient::ContentApi.new
    end

    def site_id
      ENV["SITE_IMPROVE_SITE_ID"]
    end

    def page_id_for_url(url: )
      page_list = content_api.sites_site_id_content_pages_get(site_id, url: url)
      page = page_list.items.select { |i| i.url == @url }.first
      page.id
    end
  end
end