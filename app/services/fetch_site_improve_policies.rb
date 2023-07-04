class FetchSiteImprovePolicies
  include SiteImproveApiClient

  def find(policy_id)
    policies.select { |policy| policy.id == policy_id }
  end

  def policies
    @policies ||= policy_api.sites_site_id_policy_policies_get(site_id, page_size: 500).items
  end

  def policy_api
    @policy_api ||= SiteImproveAPIClient::PolicyApi.new
  end
end
