require "gds_api/test_helpers/email_alert_api"

RSpec.describe "/metrics/base/path email subscription details", type: :feature do
  include RequestStubs
  include GdsApi::TestHelpers::EmailAlertApi

  before do
    GDS::SSO.test_user = build(:user)
    stub_metrics_page(base_path: "base/path", time_period: :past_30_days)
  end

  context "when there are subscriptions" do
    it "shows the Email subscriptions section" do
      visit "/metrics/base/path"
      expect(page).to have_content("Email subscriptions")
      expect(page).to have_content("Users signed up to get email updates about this page: 3")
      expect(page).to have_content("Users who will get email updates about changes to this page: 10")
      expect(page).not_to have_content("No subscription information found")
    end

    it "shows information on the email metrics" do
      visit "/metrics/base/path"
      [
        "This is the number of users who have signed up",
        "The number of users that get emails about changes to this page",
      ].each do |txt|
        expect(page).to have_content(txt)
      end
    end
  end

  context "when there is a 404 from email-alert-api" do
    before do
      stub_get_subscriber_list_metrics_not_found(path: "/base/path")
    end

    it "shows the no subscription info section" do
      visit "/metrics/base/path"
      expect(page).to have_content("Email subscriptions")
      expect(page).to have_content("No subscription information found")
      expect(page).not_to have_content("Users signed up to get email updates about this page:")
      expect(page).not_to have_content("Users who will get email updates about changes to this page:")
    end
  end
end
