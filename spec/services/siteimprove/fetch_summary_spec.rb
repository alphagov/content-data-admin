RSpec.describe Siteimprove::FetchSummary do
  before do
    Rails.application.config.siteimprove_site_id = 1
  end

  after do
    Rails.application.config.siteimprove_site_id = nil
  end

  it "returns no issues if the Siteimprove API isn't authorised" do
    siteimprove_is_unauthorized
    url = "https://www.gov.uk/base/path"
    issues = described_class.call(url:)

    expect(issues).to be_nil
  end
end
