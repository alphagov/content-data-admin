require "gds_api/test_helpers/email_alert_api"

RSpec.describe "/metrics/base/path email subscription details", type: :feature do
  include RequestStubs
  include GdsApi::TestHelpers::EmailAlertApi

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
      json = { subscriber_list_count: 3, all_notify_count: 10 }.to_json
      stub_get_subscriber_list_metrics(path: "/base/path", response: json)
    end

    context "when there are subscriptions" do
      it "shows the Email subscriptions section" do
        visit "/metrics/base/path"
        expect(page).to have_content("Email subscriptions")
        expect(page).to have_content("Subscribers: 3")
        expect(page).to have_content("All notification subscribers: 10")
      end
    end
  end
end
