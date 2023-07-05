class PolicyIssuesPresenter
  attr_reader :summary_info

  def initialize(policy_issues, summary_info)
    @policy_issues = policy_issues
    @summary_info = summary_info
  end

  def issue_list
    @policy_issues.map do |issue|
      {
        policy_category: issue.policy_category,
        policy_name: issue.policy_name,
        policy_priority: issue.policy_priority,
        policy_description: FetchSiteImprovePolicies.new.find(issue.id).first.note,
        policy_direct_link: "#{link}#issue/#{issue.id}",
      }
    end
  end

  def link
    summary_info._siteimprove.policy.page_report.href
  end
end
