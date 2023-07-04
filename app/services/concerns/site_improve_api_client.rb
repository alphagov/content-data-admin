require "active_support/concern"
require "site-improve-api-client"

module SiteImproveApiClient
  extend ActiveSupport::Concern

  included do
    def content_api
      @content_api ||= SiteImproveAPIClient::ContentApi.new
    end

    def site_id
      Rails.application.config.site_improve_site_id
    end

    def page_id_for_url(url:)
      raise SiteImproveAPIClient::SiteImprovePageNotFound unless site_id

      Rails.cache.fetch("site-improve-site-id-for/#{url}", expires_in: 1.hour) do
        page_list = content_api.sites_site_id_content_pages_get(site_id, url:)
        page = page_list.items.select { |i| i.url == @url }.first
        raise SiteImproveAPIClient::SiteImprovePageNotFound unless page

        page.id
      end
    end
  end
end

module SiteImproveAPIClient
  class SiteImprovePageNotFound < StandardError; end
end
