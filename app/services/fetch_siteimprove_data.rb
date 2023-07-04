require 'site-improve-api-client'

class FetchSinglePageSiteImproveAccessibilityIssues
  def content_api
    @content_api ||= SiteImproveAPIClient::ContentApi.new
  end

  def a11y_api
    @a11y_api ||= SiteImproveAPIClient::A11yApi.new
  end

  def site_id
    ENV['SITE_IMPROVE_SITE_ID']
  end

  def self.call(**args)
    new(**args).call
  end

  def initialize(url:)
    @url
  end

  def call
    page_list = content_api.sites_site_id_content_pages_get(site_id, url:)
    page = page_list.items.select { |i| i.url == url }.first

    issue_list = ally_client.sites_site_id_a11y_issue_kinds_issue_kind_pages_get(site_id, 'confirmed', page.id)
    issue_list.items.select { |i| i.conformance != "aaa" }
  end
end
