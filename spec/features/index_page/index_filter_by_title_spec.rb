RSpec.describe '/content' do
  include RequestStubs
  include TableDataSpecHelpers

  let(:items) do
    [
      { base_path: '/path/1', title: 'The title', satisfaction: nil, useful_yes: 0, useful_no: 0 },
      { base_path: '/path/2', title: 'Another title', satisfaction: nil, useful_yes: 0, useful_no: 0 }
    ]
  end

  before do
    GDS::SSO.test_user = build(:user, organisation_content_id: 'org-id')

    stub_content_page(time_period: 'last-month', organisation_id: 'all', items: items)
    visit '/content?submitted=true&date_range=last-month'
  end

  describe 'Filter by title / url' do
    before do
      stub_content_page(time_period: 'last-month', organisation_id: 'all', search_terms: 'title', items: items)

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

    it 'launches help text in a modal', js: true do
      help_string = I18n.t('metrics.upviews.about')
      expect(page).to_not have_text(help_string)
      click_link(href: "/help/?hkey=upviews")
      expect(page).to have_selector('.gem-c-modal-dialogue__box')
      expect(page).to have_text(help_string)
    end
  end
end
