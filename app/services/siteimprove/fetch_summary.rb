module Siteimprove
  class FetchSummary
    include Siteimprove::ApiSupport

    def self.call(**args)
      new(**args).call
    end

    def initialize(url:)
      @url = url
    end

    def call
      Rails.cache.fetch("siteimprove-summary-for/#{@url}", expires_in: 1.hour) do
        content_api.sites_site_id_content_pages_page_id_get(site_id, page_id_for_url(url: @url))
      end
    rescue SiteimproveAPIClient::ApiError => e
      GovukError.notify(e)
    end
  end
end
