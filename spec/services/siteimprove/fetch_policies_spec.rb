RSpec.describe Siteimprove::FetchPolicies do
  before do
    Rails.application.config.siteimprove_site_id = 1
  end

  after do
    Rails.application.config.siteimprove_site_id = nil
  end

  it "returns no issues if the Siteimprove API isn't authorised" do
    siteimprove_has_policies
    siteimprove_is_unauthorized
    issues = described_class.new.find(1)

    expect(issues).to eq([])
  end
end
