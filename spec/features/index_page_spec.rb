RSpec.describe '/content' do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:from) { Time.zone.today.last_month.beginning_of_month.to_s('%F') }
  let(:to) { Time.zone.today.last_month.end_of_month.to_s('%F') }
  let(:items) do
    [
      {
        base_path: '/path/1',
        title: 'The title',
        unique_pageviews: 233_018,
        document_type: 'news_story',
        satisfaction_score: 0.81301,
        satisfaction_score_responses: 250,
        number_of_internal_searches: 220
      },
      {
        base_path: '/path/2',
        title: 'Another title',
        unique_pageviews: 100_018,
        document_type: 'guide',
        satisfaction_score: 0.68,
        satisfaction_score_responses: 42,
        number_of_internal_searches: 12
      }
    ]
  end

  before do
    content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)
    visit "/content?date_range=last-month&organisation_id=org-id"
  end

  it 'renders the page without error' do
    expect(page.status_code).to eq(200)
    expect(page).to have_content('Content data')
  end

  it 'renders the data in a table' do
    table_rows = extract_table_content('.content-table table')
    expect(table_rows).to eq(
      [
        ['Page title', 'Content type', 'Unique pageviews', 'User satisfaction score', 'Searches from page'],
        ['The title /path/1', 'News story', '233,018', '81.3% (250 responses)', '220'],
        ['Another title /path/2', 'Guide', '100,018', '68.0% (42 responses)', '12'],
      ]
    )
  end
end
