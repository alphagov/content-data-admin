RSpec.describe Siteimprove::PolicyIssuesPresenter do
  before do
    siteimprove_has_matching_pages
    siteimprove_has_summary
    siteimprove_has_matching_policy_issues
    siteimprove_has_policies
    Rails.application.config.siteimprove_site_id = 1
  end

  after do
    Rails.application.config.siteimprove_site_id = nil
  end

  let(:url) { "https://www.gov.uk/base/path" }

  let(:summary_info) do
    Siteimprove::FetchSummary.call(url:)
  end

  let(:policy_issues) do
    Siteimprove::FetchPolicyIssues.call(url:)
  end

  describe "#any?" do
    it "returns false if there are no policy issues" do
      presenter = described_class.new([], summary_info)
      expect(presenter.any?).to be false
    end

    it "returns true if there are policy issues" do
      presenter = described_class.new(policy_issues, [])
      expect(presenter.any?).to be true
    end
  end

  describe "#issue_list" do
    it "gets the direct link to the issue" do
      presenter = described_class.new(policy_issues, summary_info)
      issue = presenter.issue_list(:all).first

      expect(issue[:policy_direct_link]).to include(policy_issues.first.id.to_s)
    end
  end

  describe "#policy_type" do
    it "gets the policy type for style issues" do
      presenter = described_class.new(policy_issues, summary_info)
      policy_name = "GDS001 - First Style Issue"

      expect(presenter.policy_type(policy_name)).to eq(:style)
    end

    it "gets the policy type for accessibility issues" do
      presenter = described_class.new(policy_issues, summary_info)
      policy_name = "AP001 - First Accessibility Issue"

      expect(presenter.policy_type(policy_name)).to eq(:accessibility)
    end
  end

  describe "#gds_policy_id" do
    it "gets the policy id from the policy name" do
      presenter = described_class.new(policy_issues, summary_info)
      policy_name = "AP001 - First Accessibility Issue"

      expect(presenter.gds_policy_id(policy_name)).to eq("AP001")
    end
  end

  describe "#policy_short_description" do
    it "gets the policy short description from the policy name" do
      presenter = described_class.new(policy_issues, summary_info)
      policy_name = "AP001 - First Accessibility Issue"

      expect(presenter.policy_short_description(policy_name)).to eq("First Accessibility Issue")
    end
  end

  describe "#policy_description" do
    it "converts the description to html" do
      presenter = described_class.new(policy_issues, summary_info)
      expect(presenter.policy_description(policy_issues.first)).to include("<p>")
    end
  end
end
