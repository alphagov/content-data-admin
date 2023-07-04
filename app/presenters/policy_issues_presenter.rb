class PolicyIssuesPresenter
  attr_reader :issue_list, :summary_info

  def initialize(issue_list, summary_info)
    @issue_list = issue_list
    @summary_info = summary_info
  end

  def link
    summary_info._siteimprove.policy.page_report.href
  end
end
