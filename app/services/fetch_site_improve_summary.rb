require "site-improve-api-client"

class FetchSiteImproveSummary
  def content_api
    @content_api ||= SiteImproveAPIClient::ContentApi.new
  end

  def site_id
    ENV["SITE_IMPROVE_SITE_ID"]
  end

  def self.call(**args)
    new(**args).call
  end

  def initialize(url:)
    @url = url
  end

  def call_raw
    page_list = content_api.sites_site_id_content_pages_get(site_id, url: @url)
    page = page_list.items.select { |i| i.url == @url }.first
    content_api.sites_site_id_content_pages_page_id_get(site_id, page.id)
  end

  def call
    page_list = content_api.sites_site_id_content_pages_get(site_id, url: @url)
    page = page_list.items.select { |i| i.url == @url }.first

    issue_list = a11y_api.sites_site_id_a11y_issue_kinds_issue_kind_pages_page_id_issues_get(site_id, "confirmed", page.id)
    issue_list.items.reject { |i| i.conformance == "aaa" }
  end
end
