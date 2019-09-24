RSpec.describe "No metric data" do
  include RequestStubs
  include TableDataSpecHelpers

  let(:document_id) { "1234:en" }
  let(:items) do
    [
      {
        "base_path" => "/parent",
        "title" => "Parent",
        "primary_organisation_id" => "7809-org",
        "document_type" => "manual",
        "sibling_order" => nil,
        "upviews" => nil,
        "pviews" => nil,
        "feedex" => nil,
        "useful_yes" => nil,
        "useful_no" => nil,
        "satisfaction" => nil,
        "searches" => nil,
      },
      {
        "base_path" => "/child/1",
        "title" => "Child 1",
        "primary_organisation_id" => "7809-org",
        "document_type" => "manual_section",
        "sibling_order" => 1,
        "upviews" => nil,
        "pviews" => nil,
        "useful_yes" => nil,
        "useful_no" => nil,
        "satisfaction" => nil,
        "searches" => nil,
      },
      {
        "base_path" => "/child/2",
        "title" => "Child 2",
        "primary_organisation_id" => "7809-org",
        "document_type" => "manual_section",
        "sibling_order" => 2,
        "upviews" => nil,
        "pviews" => nil,
        "feedex" => nil,
        "useful_yes" => nil,
        "useful_no" => nil,
        "satisfaction" => nil,
        "searches" => nil,
      },
    ]
  end

  before do
    response = { parent_base_path: "/parent", documents: items }
    stub_document_children_page(document_id: document_id, response: response)
    GDS::SSO.test_user = build(:user, organisation_content_id: "users-org-id")

    visit "/documents/#{document_id}/children"
  end

  it "renders the page without error" do
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Content Data")
  end

  it "renders the data in a table" do
    table_rows = extract_table_content(".govuk-table")
    expect(table_rows).to eq(
      [
        ["Section", "Page title", "Document type", "Unique page views", "Users who found page useful", "Searches from page"],
        ["-", "Parent /parent", "Manual", "No data", "No data", "No data"],
        ["1", "Child 1 /child/1", "Manual section", "No data", "No data", "No data"],
        ["2", "Child 2 /child/2", "Manual section", "No data", "No data", "No data"],
      ],
    )
  end
end
