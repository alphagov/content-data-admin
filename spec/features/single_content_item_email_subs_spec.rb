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
    end

    context "when there are subscriptions" do
      before do
        json = { subscriber_list_count: 3, all_notify_count: 10 }.to_json
        stub_get_subscriber_list_metrics(path: "/base/path", response: json)
      end

      it "shows the Email subscriptions section" do
        visit "/metrics/base/path"
        expect(page).to have_content("Email subscriptions")
        expect(page).to have_content("Subscribers: 3")
        expect(page).to have_content("All notification subscribers: 10")
        expect(page).not_to have_content("No subscription information found")
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
        expect(page).not_to have_content("Subscribers:")
        expect(page).not_to have_content("All notification subscribers:")
      end
    end
  end
end
