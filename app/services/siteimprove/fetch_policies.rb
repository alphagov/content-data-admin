module Siteimprove
  class FetchPolicies
    include Siteimprove::ApiSupport

    def find(policy_id)
      policies.select { |policy| policy.id == policy_id }
    end

    def policies
      Rails.cache.fetch("siteimprove-policies", expires_in: 1.hour) do
        policy_api.sites_site_id_policy_policies_get(site_id, page_size: 500).items
      end
    end

    def policy_api
      @policy_api ||= SiteimproveAPIClient::PolicyApi.new
    end
  end
end
