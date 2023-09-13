RSpec.describe Siteimprove::SummaryPresenter do
  before do
    siteimprove_has_matching_pages
    siteimprove_has_summary
    Rails.application.config.siteimprove_site_id = 1
  end

  after do
    Rails.application.config.siteimprove_site_id = nil
  end

  let(:summary_info) do
    Siteimprove::FetchSummary.call(url: "https://www.gov.uk/base/path")
  end

  describe "#accessibility_link" do
    it "replaces Accessibility with A11y in the link url and adds query params" do
      expected_link = "https://my2.siteimprove.com/Inspector/1054012/A11y/Page?pageId=2&impmd=0&conf=a+aa+aria+si"
      actual_link = described_class.new(summary_info).accessibility_link

      expect(actual_link).to eq(expected_link)
    end
  end
end
