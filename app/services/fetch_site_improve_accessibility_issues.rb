class FetchSiteImproveAccessibilityIssues
  include SiteImproveApiClient

  def a11y_api
    @a11y_api ||= SiteImproveAPIClient::A11YNextGenApi.new
  end

  def self.call(**args)
    new(**args).call
  end

  def initialize(url:, level: "confirmed")
    @url = url
    @level = level
  end

  def call_raw
    a11y_api.sites_site_id_a11y_issue_kinds_issue_kind_pages_page_id_issues_get(site_id, @level, page_id_for_url(url: @url))
  end

  def call
    issue_list = call_raw
    issue_list.items.reject { |i| i.conformance == "aaa" }
  end
end
