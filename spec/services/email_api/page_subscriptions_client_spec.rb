require "rails_helper"
require "gds_api/test_helpers/email_alert_api"

RSpec.describe EmailApi::PageSubscriptionsClient do
  include GdsApi::TestHelpers::EmailAlertApi
  subject { described_class.new }

  context "when subscription metrics exist" do
    before do
      json = { subscriber_list_count: 3, all_notify_count: 10 }.to_json
      stub_get_subscriber_list_metrics(path: "/some/path", response: json)
    end

    it "show details for the metrics" do
      metrics = subject.fetch(path: "/some/path")
      assert_equal 3, metrics.subscriber_list_count
      assert_equal 10, metrics.all_notify_count
    end
  end

  context "when subscription metrics 404" do
    before do
      stub_get_subscriber_list_metrics_not_found(path: "/some/path")
    end

    it "show details for the metrics" do
      metrics = subject.fetch(path: "/some/path")
      assert_nil metrics
    end
  end
end
