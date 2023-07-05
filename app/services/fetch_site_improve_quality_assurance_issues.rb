class FetchSiteImproveQualityAssuranceIssues
  include SiteImproveApiClient

  def quality_assurance_api
    @quality_assurance_api ||= SiteImproveAPIClient::QualityAssuranceApi.new
  end

  def self.call(**args)
    new(**args).call
  end

  def initialize(url:)
    @url = url
  end

  def call
    {
      misspellings:,
      broken_links:,
    }
  end

  def misspellings
    quality_assurance_api.sites_site_id_quality_assurance_spelling_pages_page_id_misspellings_get(site_id, page_id_for_url(url: @url)).items
  end

  def broken_links
    quality_assurance_api.sites_site_id_quality_assurance_links_pages_with_broken_links_page_id_broken_links_get(site_id, page_id_for_url(url: @url)).items
  end
end
