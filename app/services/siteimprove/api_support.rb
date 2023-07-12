require "active_support/concern"
require "siteimprove_api_client"

module Siteimprove
  class BaseError < StandardError; end
  class PageNotFound < Siteimprove::BaseError; end
  class SiteIDNotConfigured < Siteimprove::BaseError; end

  module ApiSupport
    extend ActiveSupport::Concern

    included do
      def content_api
        @content_api ||= SiteimproveAPIClient::ContentApi.new
      end

      def site_id
        Rails.application.config.siteimprove_site_id
      end

      def page_id_for_url(url:)
        raise Siteimprove::SiteIDNotConfigured unless site_id

        Rails.cache.fetch("siteimprove-site-id-for/#{url}", expires_in: 1.hour) do
          page_list = content_api.sites_site_id_content_pages_get(site_id, url:)
          page = page_list.items.select { |i| i.url == @url }.first
          raise Siteimprove::PageNotFound unless page

          page.id
        end
      end
    end
  end
end
