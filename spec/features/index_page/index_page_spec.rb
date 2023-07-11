RSpec.describe "/content" do
  include RequestStubs
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex words pdf_count satisfaction useful_yes useful_no] }
  let(:items) do
    [
      {
        base_path: "/",
        title: "GOV.UK homepage",
        organisation_id: "org-id",
        upviews: 1_233_018,
        document_type: "homepage",
        satisfaction: 0.85,
        useful_yes: 85,
        useful_no: 15,
        searches: 1220,
        reading_time: 50,
      },
      {
        base_path: "/path/1",
        title: "The title",
        organisation_id: "org-id",
        upviews: 233_018,
        document_type: "news_story",
        satisfaction: 0.813,
        useful_yes: 813,
        useful_no: 187,
        searches: 220,
        reading_time: 50,
      },
      {
        base_path: "/path/2",
        title: "Another title",
        organisation_id: "org-id",
        upviews: 100_018,
        document_type: "guide",
        satisfaction: 0.68,
        useful_yes: 34,
        useful_no: 16,
        searches: 12,
        reading_time: 50,
      },
    ]
  end

  before do
    stub_metrics_page(base_path: "path/1", time_period: :last_month)
    stub_content_page(time_period: "last-month", organisation_id: "org-id", items:)
    GDS::SSO.test_user = build(:user, organisation_content_id: "users-org-id")

    visit "/content?submitted=true&date_range=last-month&organisation_id=org-id"
  end

  it "renders the page without error" do
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Content Data")
    expect(page).to have_title("Content items - GOV.UK Content Data")
  end

  it "renders the data in a table" do
    table_rows = extract_table_content(".govuk-table")
    expect(table_rows).to eq(
      [
        ["Page title", "Document type", "Unique page views", "Users who found page useful", "Searches from page"],
        ["GOV.UK homepage /", "Homepage", "1,233,018", "85% (100 responses)", "1,220"],
        ["The title /path/1", "News story", "233,018", "81% (1,000 responses)", "220"],
        ["Another title /path/2", "Guide", "100,018", "68% (50 responses)", "12"],
      ],
    )
  end

  it "renders the link to the beta feedback" do
    expect(page).to have_link("Send us feedback", href: "#{Plek.external_url_for('support')}/content_data_feedback/new")
  end

  context "click title of an item" do
    it "takes you to single content item page" do
      click_link "The title"
      expect(current_path).to eq "/metrics/path/1"
    end

    it "respects the date filter" do
      stub_metrics_page(base_path: "path/1", time_period: :past_year)
      stub_content_page(time_period: "past-year", organisation_id: "org-id", items:)

      visit "/content?date_range=past-year&organisation_id=org-id"
      click_link "The title"
      expect(current_path).to eq "/metrics/path/1"

      expected_text = I18n.t(
        "components.time_select.title",
        time_period: I18n.t("metrics.show.time_periods.past-year.leading"),
      )
      expect(page).to have_content(expected_text)
    end
  end

  context "filter by organisation" do
    before do
      stub_content_page(time_period: "last-month", organisation_id: "another-org-id", items:)
      select "another org", from: "organisation_id"
      click_on "Filter"
    end

    it "makes request to api with correct organisation_id" do
      expect(page).to have_content("Content Data")
    end

    it "links to the page data page after filtering" do
      click_on "The title"
      expected_text = I18n.t(
        "components.time_select.title",
        time_period: I18n.t("metrics.show.time_periods.last-month.leading"),
      )
      expect(page).to have_content(expected_text)
    end

    it "selected organisation is shown in dropdown menu" do
      expect(page).to have_select("organisation_id", selected: "another org")
    end

    it "describes the filter in the table header" do
      expect(page).to have_css("h1.table-caption", exact_text: "Showing 3 results for all document types from another org")
    end

    it "respects date range" do
      stub_metrics_page(base_path: "path/1", time_period: :past_year)
      stub_content_page(time_period: "past-year", organisation_id: "another-org-id", items:)

      visit "/content?date_range=past-year&organisation_id=another-org-id"

      select "another org", from: "organisation_id"
      click_on "Filter"
      click_on "The title"
      expected_text = I18n.t(
        "components.time_select.title",
        time_period: I18n.t("metrics.show.time_periods.past-year.leading"),
      )
      expect(page).to have_content(expected_text)
    end

    context "when no organisation_id in params" do
      before do
        stub_content_page(
          time_period: "last-month",
          organisation_id: "all",
          items: [
            items[0].merge(title: "Content from all-orgs"),
          ],
        )

        visit "/content?date_range=last-month"
      end

      it "uses the `all` filter by default" do
        expect(page.status_code).to eq(200)
        expect(page).to have_content("Content from all-orgs")
      end

      it "describes the filter in the table header" do
        expect(page).to have_css("h1.table-caption", exact_text: "Showing 1 result for all document types from all organisations")
      end
    end

    context "with all organisations" do
      before do
        stub_content_page(
          time_period: "past-30-days",
          organisation_id: "users-org-id",
          items:,
        )
        stub_content_page(
          time_period: "past-30-days",
          organisation_id: "all",
          items: [items[0].merge(title: "Content from all orgs")],
        )
        visit "/content?date_range=past-30-days&organisation_id=users-org-id"
        select("All organisations", from: "organisation_id")
        click_on "Filter"
      end

      it "shows the data for all organisations" do
        expect(page.status_code).to eq(200)
        expect(page).to have_content("Content from all orgs")
      end
    end

    context "with no organisations" do
      before do
        stub_content_page(
          time_period: "past-30-days",
          organisation_id: "users-org-id",
          items:,
        )
        stub_content_page(
          time_period: "past-30-days",
          organisation_id: "none",
          items: [items[0].merge(title: "Content with no primary org")],
        )
        visit "/content?date_range=past-30-days&organisation_id=users-org-id"
        select("No primary organisation", from: "organisation_id")
        click_on "Filter"
      end

      it "shows the data no primary organisation" do
        expect(page.status_code).to eq(200)
        expect(page).to have_content("Content with no primary org")
      end
    end

    context "filter by title or slug" do
      before do
        stub_content_page(
          time_period: "past-30-days",
          organisation_id: "all",
          items:,
        )
        stub_content_page(
          time_period: "past-30-days",
          organisation_id: "all",
          search_terms: "Relevant",
          items: [items[0].merge(title: "Relevant content article")],
        )
        visit "/content?date_range=past-30-days"
        fill_in "search_term", with: "Relevant"
        click_on "Filter"
      end

      it "shows relevant content in results" do
        expect(page).to have_content("Relevant content article")
      end

      it "describes the filter in the table header" do
        expect(page).to have_css("h1.table-caption", exact_text: "Showing 1 result for 'Relevant' for all document types from all organisations")
      end
    end
  end

  context "filter by document_type" do
    before do
      stub_content_page(time_period: "last-month", organisation_id: "org-id", document_type: "news_story", items: [items.second])
      select "News story", from: "document_type"
      click_on "Filter"
    end

    it "selects the document_type in the dropdown menu" do
      expect(page).to have_select("document_type", selected: "News story")
    end

    it "renders the filtered results" do
      table_rows = extract_table_content(".govuk-table")

      _header = table_rows.shift
      expect(table_rows).to all(include("News story"))
    end

    it "describes the filter in the table header" do
      expect(page).to have_css("h1.table-caption", exact_text: "Showing 1 result for news story from org (OI)")
    end

    it "allows the filter to be cleared" do
      select "All document types", from: "document_type"
      click_on "Filter"
      expect(page).to have_select("document_type", selected: ["", "All document types"])
      table_rows = extract_table_content(".govuk-table")
      expect(table_rows.count).to eq(4)
      expect(page).to have_css("h1.table-caption", exact_text: "Showing 3 results for all document types from org (OI)")
    end
  end

  describe "no results returned" do
    before do
      stub_content_page(time_period: "past-3-months", organisation_id: "org-id", items: [])
      visit "/content?date_range=past-3-months&organisation_id=org-id"
    end

    it "shows a no data message in the table header" do
      expect(page).to have_css("h1.table-caption", exact_text: "#{I18n.t 'no_matching_results'} for all document types from org (OI)")
    end
  end

  describe "large set of results" do
    before do
      stub_content_page(time_period: "past-3-months", organisation_id: "org-id", items: items * 50)
      visit "/content?date_range=past-3-months&organisation_id=org-id"
    end

    it "formats the page numbers correctly in the table header" do
      expect(page).to have_css("h1.table-caption", exact_text: "Showing 150 results for all document types from org (OI)")
    end
  end

  describe "accessible autocomplete", js: true do
    before do
      stub_content_page(time_period: "past-3-months", organisation_id: "org-id", items: items * 50)
      visit "/content?date_range=past-3-months&organisation_id=org-id"
    end

    it "works" do
      within page.find('[data-module="accessible-autocomplete"]', text: "Document type") do |section|
        fill_in "Document type", with: ""
        expect(section).to have_css(".autocomplete__option", text: "All document types")
        expect(section).to have_css(".autocomplete__option", text: "Case study")
        expect(section).to have_css(".autocomplete__option", text: "Guide")

        fill_in "Document type", with: "C"
        expect(section).to have_css(".autocomplete__option", text: "All document types")
        expect(section).to have_css(".autocomplete__option", text: "Case study")
        expect(section).not_to have_css(".autocomplete__option", text: "Guide")

        section.find(".autocomplete__option", text: "Case study").click
        expect(section.find("select", visible: false).value).to eq("case_study")
      end
    end
  end
end
