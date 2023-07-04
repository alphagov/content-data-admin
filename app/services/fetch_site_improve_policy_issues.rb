class FetchSiteImprovePolicyIssues
  include SiteImproveApiClient

  def policy_api
    @policy_api ||= SiteImproveAPIClient::PolicyApi.new
  end

  def self.call(**args)
    new(**args).call
  end

  def initialize(url:)
    @url = url
  end

  def call
    policy_api.sites_site_id_policy_pages_page_id_matching_policies_get(site_id, page_id_for_url(url: @url)).items
  end
end
