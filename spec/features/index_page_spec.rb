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
    stub_metrics_page(base_path: 'path/1', time_period: :last_month)
    content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)
    GDS::SSO.test_user = build(:user, organisation_content_id: 'users-org-id')
    content_data_api_has_orgs
    content_data_api_has_document_types

    visit "/content?date_range=last-month&organisation_id=org-id"
  end

  it 'renders the page without error' do
    expect(page.status_code).to eq(200)
    expect(page).to have_content('Content data')
  end

  it 'renders the data in a table' do
    table_rows = extract_table_content('.govuk-table')
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
      stub_metrics_page(base_path: 'path/1', time_period: :last_year)
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', items: items)

      visit "/content?date_range=last-year&organisation_id=org-id"
      click_link 'The title'
      expect(current_path).to eq '/metrics/path/1'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.last-year.leading')}")
    end
  end

  context 'filter by organisation' do
    before do
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'another-org-id', items: items)
      select 'another org', from: 'organisation_id'
      click_on 'Filter'
    end

    it 'makes request to api with correct organisation_id' do
      expect(page).to have_content('Content data')
    end

    it 'links to the page data page after filtering' do
      click_on 'The title'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.last-month.leading')}")
    end

    it 'selected organisation is shown in dropdown menu' do
      expect(page).to have_select('organisation_id', selected: 'another org')
    end

    it 'respects date range' do
      from = (Time.zone.today - 1.year).to_s('%F')
      to = Time.zone.today.to_s('%F')
      stub_metrics_page(base_path: 'path/1', time_period: :last_year)
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'another-org-id', items: items)

      visit "/content?date_range=last-year&organisation_id=another-org-id"

      select 'another org', from: 'organisation_id'
      click_on 'Filter'
      click_on 'The title'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.last-year.leading')}")
    end

    context 'with users organisation' do
      before do
        content_data_api_has_content_items(
          from: from,
          to: to,
          organisation_id: 'users-org-id',
          items: [
            items[0].merge(title: 'Content from users-org-id')
          ]
        )

        visit "/content?date_range=last-month"
      end

      it 'uses the users organisation by default' do
        expect(page.status_code).to eq(200)
        expect(page).to have_content('Content from users-org-id')
      end
    end
  end

  context 'filter by document_type' do
    before do
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', document_type: 'news_story', items: [items.first])
      select 'News story', from: 'document_type'
      click_on 'Filter'
    end

    it 'selects the document_type in the dropdown menu' do
      expect(page).to have_select('document_type', selected: 'News story')
    end

    it 'renders the filtered results' do
      table_rows = extract_table_content('.govuk-table')

      _header = table_rows.shift
      expect(table_rows).to all(include('News story'))
    end

    it 'Allows the filter to be cleared' do
      select 'All document types', from: 'document_type'
      click_on 'Filter'
      expect(page).to have_select('document_type', selected: nil)
      table_rows = extract_table_content('.govuk-table')
      expect(table_rows.count).to eq(3)
    end
  end

  context 'pagination' do
    let(:other_page_items) do
      [
        {
          base_path: '/path/3',
          title: 'third title',
          upviews: 233_018,
          document_type: 'press_release',
          satisfaction: 0.81301,
          satisfaction_responses: 250,
          searches: 220
        },
        {
          base_path: '/path/4',
          title: 'forth title',
          upviews: 100_018,
          document_type: 'news_story',
          satisfaction: 0.68,
          satisfaction_responses: 42,
          searches: 12
        }
      ]
    end

    before do
      content_data_api_has_content_items(from: from, to: to, organisation_id: 'org-id', page: 2, items: other_page_items)
    end

    it 'shows the second page of data' do
      click_on 'Next'
      table_rows = extract_table_content('.govuk-table')
      expect(table_rows).to eq(
        [
          ['Page title', 'Content type', 'Unique pageviews', 'User satisfaction score', 'Searches from page'],
          ['third title /path/3', 'Press release', '233,018', '81.3% (250 responses)', '220'],
          ['forth title /path/4', 'News story', '100,018', '68.0% (42 responses)', '12'],
        ]
      )
    end
  end
end
