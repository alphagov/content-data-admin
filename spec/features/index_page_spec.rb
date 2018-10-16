RSpec.describe '/content' do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex words pdf_count satisfaction useful_yes useful_no] }
  let(:from) { Time.zone.today.last_month.beginning_of_month.to_s('%F') }
  let(:to) { Time.zone.today.last_month.end_of_month.to_s('%F') }
  let(:items) do
    [
      {
        base_path: '/path/1',
        title: 'The title',
        upviews: 233_018,
        document_type: 'news_story',
        satisfaction: 0.81301,
        satisfaction_responses: 250,
        searches: 220
      },
      {
        base_path: '/path/2',
        title: 'Another title',
        upviews: 100_018,
        document_type: 'guide',
        satisfaction: 0.68,
        satisfaction_responses: 42,
        searches: 12
      }
    ]
  end

  before do
    content_data_api_has_single_page(base_path: 'path/1', from: from, to: to)
    content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)
    content_data_has_orgs
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

  context 'click title of an item' do
    it 'takes you to single content item page' do
      click_link 'The title'
      expect(current_path).to eq '/metrics/path/1'
    end

    it 'respects the date filter' do
      from = (Time.zone.today - 1.year).to_s('%F')
      to = Time.zone.today.to_s('%F')
      content_data_api_has_single_page(base_path: 'path/1', from: from, to: to)
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)

      visit "/content?date_range=last-year&organisation_id=org-id"
      click_link 'The title'
      expect(current_path).to eq '/metrics/path/1'
      expect(page).to have_content('Page data: Past year')
    end
  end

  context 'filter by organisation' do
    before do
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'another-org-id', items: items)
      organisation_dropdown = find('.org-picker')
      organisation_dropdown.select('another org')
      click_on 'Filter'
    end

    it 'makes request to api with correct organisation_id' do
      expect(page).to have_content('Content data')
    end

    it 'links to the page data page after filtering' do
      click_on 'The title'
      expect(page).to have_content('Page data: Last month')
    end

    it 'respects date range' do
      from = (Time.zone.today - 1.year).to_s('%F')
      to = Time.zone.today.to_s('%F')
      content_data_api_has_single_page(base_path: 'path/1', from: from, to: to)
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'another-org-id', items: items)

      visit "/content?date_range=last-year&organisation_id=another-org-id"

      organisation_dropdown = find('.org-picker')
      organisation_dropdown.select('another org')
      click_on 'Filter'
      click_on 'The title'
      expect(page).to have_content('Page data: Past year')
    end
  end
end
