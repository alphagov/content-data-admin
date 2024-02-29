require "gds_api/test_helpers/search"

RSpec.describe "PartialSitemapGenerator" do
  include GdsApi::TestHelpers::Search

  subject { PartialSitemapGenerator.new }

  describe "#generate_for_organisations" do
    before do
      ENV["AWS_SITEIMPROVE_SITEMAPS_BUCKET_NAME"] = "test-bucket"
    end

    context "with an empty organisation list" do
      it "raises an error" do
        expect { subject.generate_for_organisations }.to raise_error(StandardError, "No organisations specified")
      end
    end

    context "with no pages for the sitemap" do
      before do
        stub_any_search_to_return_no_results
      end

      it "raises an error" do
        expect { subject.generate_for_organisations(organisations: %w[bogus-organisation]) }.to raise_error(StandardError, "Sitemap empty (are the organisation slugs correct?)")
      end
    end

    context "with organisations that have pages" do
      before do
        stub_any_search.to_return(body: { results: [{ "link" => "https://www.example.com/" }] }.to_json)
      end

      context "with a single org" do
        it "returns the sitemap public URL" do
          expect(subject.generate_for_organisations(organisations: %w[bogus-organisation])).to eq("https://test-bucket.s3.amazonaws.com/sitemap-bogus-organisation.xml.gz")
        end
      end

      context "with multiple orgs" do
        it "returns the sitemap public URL" do
          expect(subject.generate_for_organisations(organisations: %w[bogus-organisation my-org])).to eq("https://test-bucket.s3.amazonaws.com/sitemap-bogus-organisation-and-my-org.xml.gz")
        end
      end
    end
  end
end
