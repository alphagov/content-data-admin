RSpec.describe "Results pagination" do
  include RequestStubs
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex words pdf_count satisfaction useful_yes useful_no] }

  context 'has no results' do
    before do
      GDS::SSO.test_user = build(:user, organisation_content_id: 'users-org-id')
      stub_content_page(time_period: 'last-month', organisation_id: 'org-id', items: [])

      visit "/content?date_range=last-month&organisation_id=org-id"
    end

    it 'has GTM data attributes' do
      expect(page).to have_css('[data-gtm-total-results]')

      total_results = page.find('[data-gtm-total-results]')['data-gtm-total-results']
      expect(total_results).to eq('0')
    end
  end

  context 'has results' do
    let(:items) do
      [
        {
          base_path: '/',
          title: 'GOV.UK homepage',
          organisation_id: 'org-id',
          upviews: 1_233_018,
          document_type: 'homepage',
          satisfaction: 0.85,
          satisfaction_score_responses: 2050,
          searches: 1220
        },
        {
          base_path: '/path/1',
          title: 'The title',
          organisation_id: 'org-id',
          upviews: 233_018,
          document_type: 'news_story',
          satisfaction: 0.81301,
          satisfaction_score_responses: 250,
          searches: 220
        },
        {
          base_path: '/path/2',
          title: 'Another title',
          organisation_id: 'org-id',
          upviews: 100_018,
          document_type: 'guide',
          satisfaction: 0.68,
          satisfaction_score_responses: 42,
          searches: 12
        }
      ]
    end
    let(:other_page_items) do
      [
        {
          base_path: '/path/3',
          title: 'third title',
          upviews: 233_018,
          document_type: 'press_release',
          satisfaction: 0.81301,
          satisfaction_score_responses: 250,
          searches: 220
        },
        {
          base_path: '/path/4',
          title: 'forth title',
          upviews: 100_018,
          document_type: 'news_story',
          satisfaction: 0.68,
          satisfaction_score_responses: 42,
          searches: 12
        }
      ]
    end

    before do
      GDS::SSO.test_user = build(:user, organisation_content_id: 'users-org-id')
      stub_content_page(
        time_period: 'last-month',
        organisation_id: 'org-id',
        items: (items[1..-1] * 50) + other_page_items
      )

      visit "/content?date_range=last-month&organisation_id=org-id"
    end

    it 'shows the second page of data' do
      expect(page).to have_css('h1.table-header', exact_text: 'Showing 1 to 100 of 102 results from org (OI)')
      click_on 'Next'
      table_rows = extract_table_content('.govuk-table')
      expect(table_rows).to eq(
        [
          ['Page title', 'Document type', 'Unique pageviews', 'User satisfaction score', 'Searches from the page'],
          ['third title /path/3', 'Press release', '233,018', '81% (250 responses)', '220'],
          ['forth title /path/4', 'News story', '100,018', '68% (42 responses)', '12'],
        ]
      )
      expect(page).to have_css('h1.table-header', exact_text: 'Showing 101 to 102 of 102 results from org (OI)')
    end

    it 'has GTM data attributes' do
      expect(page).to have_css('[data-gtm-total-results]')

      total_results = page.find('[data-gtm-total-results]')['data-gtm-total-results']
      expect(total_results).to eq('102')
    end
  end
end
