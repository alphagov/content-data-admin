RSpec.describe '/content' do
  include RequestStubs
  include TableDataSpecHelpers

  let(:items) do
    [
      { base_path: '/path/1', title: 'The title' },
      { base_path: '/path/2', title: 'Another title' }
    ]
  end

  before do
    GDS::SSO.test_user = build(:user, organisation_content_id: 'org-id')

    stub_content_page(time_period: 'last-month', organisation_id: 'org-id', items: items)

    visit '/content?submitted=true&date_range=last-month&organisation_id=org-id'
  end

  describe 'Filter by title / url' do
    before do
      stub_content_page(time_period: 'last-month', organisation_id: 'org-id', search_terms: 'title', items: items)

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
