RSpec.feature "Sort results" do
  include RequestStubs
  let(:items) do
    [
      {
        base_path: "/",
        title: "A",
        organisation_id: "org-id",
        upviews: 300,
        document_type: "homepage",
        satisfaction: 0.50,
        useful_yes: 5,
        useful_no: 5,
        searches: 1,
      },
      {
        base_path: "/path/1",
        title: "C",
        organisation_id: "org-id",
        upviews: 200,
        document_type: "news_story",
        satisfaction: 0.75,
        useful_yes: 75,
        useful_no: 25,
        searches: 2,
      },
      {
        base_path: "/path/2",
        title: "B",
        organisation_id: "org-id",
        upviews: 100,
        document_type: "guide",
        satisfaction: 0.25,
        useful_yes: 25,
        useful_no: 75,
        searches: 3,
      },
    ]
  end

  scenario "visit the content page" do
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: items)
    visit "/content"

    values = extract_table_column_values("upviews")
    expect(values).to eq(%w[300 200 100])
  end

  scenario "sort on title column is disabled" do
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: items)
    visit "/content"

    within('th[data-gtm-id="title-column"]') do
      expect(page).not_to have_selector(".table__sort-link")
    end
  end

  scenario "sort on document_type column" do
    sorted_items = items.sort_by { |item| item[:document_type] }
    sorted_items.reverse!
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: items)
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: sorted_items, sort: "document_type:asc")
    visit "/content"
    find('th[data-gtm-id="document_type-column"] > a').click

    values = extract_table_column_values("document_type")
    expect(values).to eq(["News story", "Homepage", "Guide"])
  end

  scenario "sort on satisfaction column" do
    sorted_items = items.sort_by { |item| item[:satisfaction] }
    sorted_items.reverse!
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: items)
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: sorted_items, sort: "satisfaction:desc")
    visit "/content"
    find('th[data-gtm-id="satisfaction-column"] > .table__sort-link').click

    values = extract_table_column_values("satisfaction")
    expect(values).to eq(["75% (100 responses)", "50% (10 responses)", "25% (100 responses)"])
  end

  scenario "sort on searches column" do
    sorted_items = items.sort_by { |item| item[:searches] }
    sorted_items.reverse!
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: items)
    stub_content_page(time_period: "past-30-days", organisation_id: "all", items: sorted_items, sort: "searches:desc")
    visit "/content"
    find('th[data-gtm-id="searches-column"] > .table__sort-link').click

    values = extract_table_column_values("searches")
    expect(values).to eq(%w[3 2 1])
  end
end

def extract_table_column_values(column)
  find("table").all("tr > td[data-gtm-id=\"#{column}-column\"]").map(&:text)
end
