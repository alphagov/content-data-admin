class SiteImproveSummaryPresenter
  attr_reader :summary_info

  def initialize(summary_info)
    @summary_info = summary_info
  end

  def accessibility_link
    uri = URI.parse(summary_info._siteimprove.accessibility.page_report.href)
    uri.path = uri.path.gsub(/Accessibility/, "A11y")
    uri.query += "&conf=a+aa+aria+si"
    uri.to_s
  end

  def policy_link
    summary_info._siteimprove.policy.page_report.href
  end

  def seo_link
    summary_info._siteimprove.seo.page_report.href
  end

  def quality_assurance_link
    summary_info._siteimprove.quality_assurance.page_report.href
  end
end
