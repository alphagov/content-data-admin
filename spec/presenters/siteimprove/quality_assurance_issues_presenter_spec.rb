RSpec.describe Siteimprove::QualityAssuranceIssuesPresenter do
  before do
    siteimprove_has_matching_pages
    siteimprove_has_summary
    siteimprove_has_policies
    Rails.application.config.siteimprove_site_id = 1
    @link_title_resolver = double
    allow(@link_title_resolver).to receive(:title_for_link).and_return("Link Text")
  end

  after do
    Rails.application.config.siteimprove_site_id = nil
  end

  let(:url) { "https://www.gov.uk/base/path" }

  let(:summary_info) do
    Siteimprove::FetchSummary.call(url:)
  end

  let(:quality_assurance_issues) do
    Siteimprove::FetchQualityAssuranceIssues.call(url:)
  end

  describe "#any?" do
    it "returns true if there are misspellings" do
      siteimprove_has_misspellings
      siteimprove_has_no_broken_links

      presenter = described_class.new(quality_assurance_issues, summary_info, @link_title_resolver)
      expect(presenter.any?).to be true
    end

    it "returns true if there are broken links" do
      siteimprove_has_no_misspellings
      siteimprove_has_broken_links

      presenter = described_class.new(quality_assurance_issues, summary_info, @link_title_resolver)
      expect(presenter.any?).to be true
    end

    it "returns true if there are misspellings and broken links" do
      siteimprove_has_misspellings
      siteimprove_has_broken_links

      presenter = described_class.new(quality_assurance_issues, summary_info, @link_title_resolver)
      expect(presenter.any?).to be true
    end

    it "returns false if there are no misspellings or broken links" do
      siteimprove_has_no_misspellings
      siteimprove_has_no_broken_links

      presenter = described_class.new(quality_assurance_issues, summary_info, @link_title_resolver)
      expect(presenter.any?).to be false
    end
  end

  describe "#misspellings" do
    before do
      siteimprove_has_misspellings
      siteimprove_has_no_broken_links
    end

    it "returns spelling suggestions as a string" do
      misspellings = described_class.new(quality_assurance_issues, summary_info, @link_title_resolver).misspellings
      expect(misspellings.first[:suggestions]).to eq("fish, phish")
    end

    it "gets the direct link to the misspelling in the page report" do
      misspellings = described_class.new(quality_assurance_issues, summary_info, @link_title_resolver).misspellings
      expected_link = "https://my2.siteimprove.com/Inspector/1054012/QualityAssurance/Page?impmd=0&PageId=2#/Issue/Misspellings/0"

      expect(misspellings.first[:quality_assurance_direct_link]).to eq(expected_link)
    end
  end

  describe "#broken_links" do
    before do
      siteimprove_has_no_misspellings
      siteimprove_has_broken_links
    end

    it "gets the direct link to the broken link in the page report" do
      broken_links = described_class.new(quality_assurance_issues, summary_info, @link_title_resolver).broken_links
      expected_link = "https://my2.siteimprove.com/Inspector/1054012/QualityAssurance/Page?impmd=0&PageId=2#/Issue/BrokenLinks/0"

      expect(broken_links.first[:quality_assurance_direct_link]).to eq(expected_link)
    end
  end
end
