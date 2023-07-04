class FetchSiteImproveSummary
  include SiteImproveApiClient

  def self.call(**args)
    new(**args).call
  end

  def initialize(url:)
    @url = url
  end

  def call
    content_api.sites_site_id_content_pages_page_id_get(site_id, page_id_for_url(url: @url))
  end
end
