module Siteimprove
  class FetchMetrics
    include Siteimprove::ApiSupport
    attr_reader :base_path, :has_accessibility_info

    def initialize(base_path)
      @base_path = base_path
    end

    def has_accessibility_info?
      policy_issues.any? || quality_assurance_issues.any?
    rescue Siteimprove::BaseError
      false
    end

    def policy_issues
      raw_policy_issues = Siteimprove::FetchPolicyIssues.call(url:)
      Siteimprove::PolicyIssuesPresenter.new(raw_policy_issues, summary_info)
    end

    def quality_assurance_issues
      raw_quality_assurance_issues = Siteimprove::FetchQualityAssuranceIssues.call(url:)
      Siteimprove::QualityAssuranceIssuesPresenter.new(raw_quality_assurance_issues, summary_info)
    end

    def summary_info
      @summary_info ||= Siteimprove::FetchSummary.call(url:)
    end

    def url
      "https://www.gov.uk/#{base_path}"
    end
  end
end
