require "rails_helper"
require "gds_api/test_helpers/content_store"

RSpec.describe LinkTitleResolver do
  include GdsApi::TestHelpers::ContentStore

  subject { described_class.new("/broken-link-page") }

  describe "#title_for_link" do
    context "when the link can't be found" do
      before do
        stub_content_store_has_item("/broken-link-page", { "details" => { "body" => "No links here!" } })
      end

      it "returns (unable to find link text)" do
        expect(subject.title_for_link("https://missing.io")).to eq("(Unable to find link text)")
      end
    end

    context "when the content data has a single body" do
      before do
        stub_content_store_has_item("/broken-link-page", { "details" => { "body" => "<a href=\"https://missing.io\">Relevant Link</a>" } })
      end

      it "returns the link text" do
        expect(subject.title_for_link("https://missing.io")).to eq("Relevant Link")
      end
    end

    context "when the content data has parts" do
      before do
        stub_content_store_has_item("/broken-link-page", { "details" => { "parts" => [{ "body" => "<a href=\"https://present.io\">Irrelevant Link</a>" }, { "body" => "<a href=\"https://missing.io\">Relevant Link</a>" }] } })
      end

      it "returns the link text" do
        expect(subject.title_for_link("https://missing.io")).to eq("Relevant Link")
      end
    end
  end
end
