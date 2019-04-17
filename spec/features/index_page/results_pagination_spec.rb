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
          useful_yes: 85,
          useful_no: 15,
          searches: 1220
        },
        {
          base_path: '/path/1',
          title: 'The title',
          organisation_id: 'org-id',
          upviews: 233_018,
          document_type: 'news_story',
          satisfaction: 0.813,
          useful_yes: 813,
          useful_no: 187,
          searches: 220
        },
        {
          base_path: '/path/2',
          title: 'Another title',
          organisation_id: 'org-id',
          upviews: 100_018,
          document_type: 'guide',
          satisfaction: 0.68,
          useful_yes: 34,
          useful_no: 16,
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
          satisfaction: 0.813,
          useful_yes: 813,
          useful_no: 187,
          searches: 220
        },
        {
          base_path: '/path/4',
          title: 'forth title',
          upviews: 100_018,
          document_type: 'news_story',
          satisfaction: 0.68,
          useful_yes: 34,
          useful_no: 16,
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
      expect(page).to have_css('h1.table-caption', exact_text: 'Showing 102 results for all document types from org (OI)')
      click_on 'Next'
      table_rows = extract_table_content('.govuk-table')
      expect(table_rows).to eq(
        [
          ['Page title', 'Document type', 'Unique pageviews', 'User satisfaction score', 'Searches from the page'],
          ['third title /path/3', 'Press release', '233,018', '81% (1,000 responses)', '220'],
          ['forth title /path/4', 'News story', '100,018', '68% (50 responses)', '12'],
        ]
      )
      expect(page).to have_css('h1.table-caption', exact_text: 'Showing 102 results for all document types from org (OI)')
    end
  end
end
