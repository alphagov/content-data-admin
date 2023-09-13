require "rails_helper"

RSpec.describe SiteimproveRedirectController, type: :controller do
  before do
    siteimprove_has_matching_pages
    siteimprove_has_summary
    Rails.application.config.siteimprove_site_id = 1
  end

  after do
    Rails.application.config.siteimprove_site_id = nil
  end

  it "redirects to the Quality Assurance tab" do
    expect(get(:quality_assurance, params: { base_path: "base/path" })).to redirect_to("https://my2.siteimprove.com/QualityAssurance/1054012/PageDetails/Report?impmd=0&PageId=2")
  end

  it "redirects to the Accessibility tab" do
    expect(get(:accessibility, params: { base_path: "base/path" })).to redirect_to("https://my2.siteimprove.com/Inspector/1054012/A11y/Page?pageId=2&impmd=0&conf=a+aa+aria+si")
  end

  it "redirects to the SEO tab" do
    expect(get(:seo, params: { base_path: "base/path" })).to redirect_to("https://my2.siteimprove.com/Inspector/1054012/SeoV2/Page?pageId=2&impmd=0")
  end

  it "redirects to the Policy tab" do
    expect(get(:policy, params: { base_path: "base/path" })).to redirect_to("https://my2.siteimprove.com/Inspector/1054012/Policy/Page?pageId=2&impmd=0")
  end

  context "without the page" do
    before do
      siteimprove_has_no_matching_pages
    end

    it "returns a 404" do
      get(:policy, params: { base_path: "base/path" })
      expect(response.status).to eq(404)
    end
  end
end
