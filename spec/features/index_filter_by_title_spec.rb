RSpec.describe '/content' do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers

  let(:from) { Time.zone.today.last_month.beginning_of_month.to_s('%F') }
  let(:to) { Time.zone.today.last_month.end_of_month.to_s('%F') }
  let(:items) do
    [
      { base_path: '/path/1', title: 'The title' },
      { base_path: '/path/2', title: 'Another title' }
    ]
  end

  before do
    GDS::SSO.test_user = build(:user, organisation_content_id: 'org-id')

    content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)
    content_data_api_has_orgs
    content_data_api_has_document_types

    visit '/content?date_range=last-month&organisation_id=org-id'
  end

  describe 'Filter by title / url' do
    before do
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', search_term: 'title', items: items)
      fill_in 'Search for a title or URL', with: 'title'
      click_on 'Filter'
    end

    it 'renders the filtered items' do
      table_rows = extract_table_content('.govuk-table')

      _header = table_rows.shift
      expect(table_rows.length).to eq(2)
      expect(table_rows[0]).to include('The title /path/1')
      expect(table_rows[1]).to include('Another title /path/2')
    end

    it 'populates the search field with the current filter' do
      expect(page).to have_selector('input[name=search_term][value=title]')
    end
  end
end
