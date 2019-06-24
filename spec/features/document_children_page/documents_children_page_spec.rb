RSpec.describe '/documents/:document_id/children' do
  include RequestStubs
  include TableDataSpecHelpers

  before do
    # stub_metrics_page(base_path: 'path/1', time_period: :last_month)
    GDS::SSO.test_user = build(:user, organisation_content_id: 'users-org-id')

    visit "/documents/1234:en/children?date_range=last-month"
  end

  it 'renders the page without error' do
    expect(page.status_code).to eq(200)
    expect(page).to have_content('Content data')
  end

  it 'renders the data in a table' do
    table_rows = extract_table_content('.govuk-table')
    expect(table_rows).to eq(
      [
        ['Section', 'Page title', 'Document type', 'Unique pageviews', 'Users who found page useful', 'Searches from page'],
        ['-', 'Parent /parent', 'Manual', '10', '75% (100 responses)', '3'],
        ['1', 'Child 1 /child/1', 'Manual section', '1,000,000', '75% (100 responses)', '3'],
        ['2', 'Child 2 /child/2', 'Manual section', '0', '75% (100 responses)', '3'],
      ]
    )
  end

  it 'renders the link to the beta feedback' do
    expect(page).to have_link("Send us feedback", href: Plek.new.external_url_for('support') + '/content_data_feedback/new')
  end

  it 'renders the page title' do
    expect(page).to have_title('Parent: Manual comparision')
  end

  it 'renders the page kicker' do
    expect(page).to have_content('Manual comparision')
  end

  it 'renders the page heading' do
    expect(page).to have_content('Parent')
  end

  context 'click title of an item' do
    it 'takes you to single content item page' do
      click_link 'Parent'
      expect(current_path).to eq '/metrics/parent'
    end
  end
end
