class AccessibilityIssuesPresenter
  attr_reader :issue_list, :summary_info, :link

  def initialize(issue_list, summary_info)
    @issue_list = issue_list
    @summary_info = summary_info
    @link = make_link(summary_info._siteimprove.accessibility.page_report.href)
  end

  def make_link(initial_url)
    uri = URI.parse(initial_url)
    uri.path = uri.path.gsub(/Accessibility/, "A11y")
    uri.query += "&conf=a+aa+aria+si"
    uri.to_s
  end
end
