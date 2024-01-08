RSpec.describe "/metrics/base/path email subscription details", type: :feature do
  include RequestStubs

  context "logged in as another department" do
    before do
      GDS::SSO.test_user = build(:user)
      stub_metrics_page(base_path: "base/path", time_period: :past_30_days)
    end

    it "does not show the Email Subscriptions title" do
      visit "/metrics/base/path"
      expect(page).not_to have_content("Email subscriptions")
    end
  end

  context "logged in as GDS" do
    before do
      GDS::SSO.test_user = build(:view_email_subs_user)
      stub_metrics_page(base_path: "base/path", time_period: :past_30_days)
    end

    it "shows the Email subscriptions section" do
      visit "/metrics/base/path"
      expect(page).to have_content("Email subscriptions")
    end
  end
end
