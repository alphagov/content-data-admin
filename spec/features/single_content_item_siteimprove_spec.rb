RSpec.describe "/metrics/base/path Siteimprove features", type: :feature do
  include RequestStubs

  context "logged in" do
    before do
      GDS::SSO.test_user = build(:user)
      stub_metrics_page(base_path: "base/path", time_period: :past_30_days)
      Rails.application.config.siteimprove_site_id = 1
    end

    after do
      Rails.application.config.siteimprove_site_id = nil
    end

    context "when siteimprove is unauthorized" do
      before do
        siteimprove_is_unauthorized
      end

      it "does not show Siteimprove title" do
        visit "/metrics/base/path"
        expect(page).not_to have_content("Content issues identified by Siteimprove")
      end
    end

    context "when siteimprove has no matching pages" do
      before do
        siteimprove_has_no_matching_pages
      end

      it "does not show Siteimprove title" do
        visit "/metrics/base/path"
        expect(page).not_to have_content("Content issues identified by Siteimprove")
      end
    end

    context "when siteimprove has imperfectly matching pages" do
      before do
        siteimprove_has_imperfectly_matching_pages
      end

      it "does not show Siteimprove title" do
        visit "/metrics/base/path"
        expect(page).not_to have_content("Content issues identified by Siteimprove")
      end
    end

    context "when siteimprove has matching pages" do
      before do
        siteimprove_has_matching_pages
        siteimprove_has_summary
      end

      context "but there are no issues" do
        before do
          siteimprove_has_no_matching_policy_issues
        end

        it "does not show Siteimprove title" do
          visit "/metrics/base/path"
          expect(page).not_to have_content("Content issues identified by Siteimprove")
        end
      end

      context "and matching policy issues exist" do
        before do
          siteimprove_has_matching_policy_issues
          siteimprove_has_policies
          siteimprove_has_no_misspellings
          siteimprove_has_no_broken_links
        end

        it "shows Siteimprove title" do
          visit "/metrics/base/path"
          expect(page).to have_content("Content issues identified by Siteimprove")
        end

        it "shows Siteimprove issues" do
          visit "/metrics/base/path"
          expect(page).to have_content("Style issues on the page")
          expect(page).to have_content("First Style Issue")
          expect(page).to have_content("Description of GDS001")
        end

        it "shows Accesibility issues" do
          visit "/metrics/base/path"
          expect(page).to have_content("Accessibility issues on the page")
          expect(page).to have_content("First Accessibility Issue")
          expect(page).to have_content("Description of GDSA021")
        end
      end

      context "and misspellings exist" do
        before do
          siteimprove_has_no_matching_policy_issues
          siteimprove_has_policies
          siteimprove_has_misspellings
          siteimprove_has_no_broken_links
        end

        it "shows Siteimprove title" do
          visit "/metrics/base/path"
          expect(page).to have_content("Content issues identified by Siteimprove")
        end

        it "shows Misspellings" do
          visit "/metrics/base/path"
          expect(page).to have_content("Misspellings on the page")
          expect(page).to have_content("phish")
          expect(page).to have_content("fish")
        end
      end
    end
  end
end
