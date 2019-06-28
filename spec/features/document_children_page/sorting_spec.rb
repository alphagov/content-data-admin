RSpec.feature "Sort results" do
  include RequestStubs

  let(:document_id) { '1234:en' }
  let(:page_url) { "/documents/#{document_id}/children" }
  let(:items) do
    [
      {
        "base_path" => '/parent',
        "title" => "Parent",
        "primary_organisation_id" => "7809-org",
        "document_type" => "manual",
        "sibling_order" => nil,
        "upviews" => 10,
        "pviews" => 2,
        "feedex" => 0,
        "useful_yes" => 75,
        "useful_no" => 25,
        "satisfaction" => 0.75,
        "searches" => 1
      },
      {
        "base_path" => "/child/1",
        "title" => "Child 1",
        "primary_organisation_id" => "7809-org",
        "document_type" => "manual_section",
        "sibling_order" => 1,
        "upviews" => 100,
        "pviews" => 2,
        "feedex" => 0,
        "useful_yes" => 50,
        "useful_no" => 50,
        "satisfaction" => 0.5,
        "searches" => 2
      },
      {
        "base_path" => "/child/2",
        "title" => "Child 2",
        "primary_organisation_id" => "7809-org",
        "document_type" => "manual_section",
        "sibling_order" => 2,
        "upviews" => 0,
        "pviews" => 2,
        "feedex" => 0,
        "useful_yes" => 25,
        "useful_no" => 75,
        "satisfaction" => 0.25,
        "searches" => 3
      }
    ]
  end

  scenario 'visit the content page' do
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'sibling_order:asc')

    visit page_url

    values = extract_table_column_values('sibling_order')
    expect(values).to eq(%w[- 1 2])
  end

  scenario 'sort on title column is disabled' do
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'sibling_order:asc')

    visit page_url

    within('th[data-gtm-id="title-column"]') do
      expect(page).not_to have_selector('.table__sort-link')
    end
  end

  scenario 'sort on document type column is disabled' do
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'sibling_order:asc')

    visit page_url

    within('th[data-gtm-id="document_type-column"]') do
      expect(page).not_to have_selector('.table__sort-link')
    end
  end

  scenario 'sort on unique page views column' do
    sorted_items = items.sort_by { |item| item['upviews'] }
    sorted_items.reverse!

    response = { parent_base_path: '/parent', documents: sorted_items }
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'sibling_order:asc')
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'upviews:desc', response: response)

    visit page_url
    find('th[data-gtm-id="upviews-column"] > .table__sort-link').click

    values = extract_table_column_values('upviews')
    expect(values).to eq(%w[100 10 0])
  end

  scenario 'sort on satisfaction column' do
    sorted_items = items.sort_by { |item| item['satisfaction'] }
    sorted_items.reverse!

    response = { parent_base_path: '/parent', documents: sorted_items }
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'sibling_order:asc')
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'satisfaction:desc', response: response)

    visit page_url
    find('th[data-gtm-id="satisfaction-column"] > .table__sort-link').click

    values = extract_table_column_values('satisfaction')
    expect(values).to eq(['75% (100 responses)', '50% (100 responses)', '25% (100 responses)'])
  end

  scenario 'sort on searches column' do
    sorted_items = items.sort_by { |item| item['searches'] }
    sorted_items.reverse!

    response = { parent_base_path: '/parent', documents: sorted_items }
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'sibling_order:asc')
    stub_document_children_page(document_id: document_id, time_period: 'past-30-days', sort: 'searches:desc', response: response)

    visit page_url
    find('th[data-gtm-id="searches-column"] > .table__sort-link').click

    values = extract_table_column_values('searches')
    expect(values).to eq(%w[3 2 1])
  end
end

def extract_table_column_values(column)
  find('table').all("tr > td[data-gtm-id=\"#{column}-column\"]").map(&:text)
end
