require "govspeak"

module Siteimprove
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
          gds_policy_id: gds_policy_id(issue.policy_name),
          policy_short_description: policy_short_description(issue.policy_name),
          policy_priority: issue.policy_priority,
          policy_description: policy_description(issue),
          policy_direct_link: "#{link}#issue/#{issue.id}",
        }
      end
    end

    def link
      summary_info._siteimprove.policy.page_report.href
    end

    def gds_policy_id(policy_name)
      policy_name.split(" - ").first
    end

    def policy_short_description(policy_name)
      policy_name.split(" - ").last
    end

    def policy_description(issue)
      note = Siteimprove::FetchPolicies.new.find(issue.id).first.note
      note.gsub!(/https:\/\/(.+)/, "[https://\\1](https://\\1)")
      Govspeak::Document.new(note).to_html
    end
  end
end
