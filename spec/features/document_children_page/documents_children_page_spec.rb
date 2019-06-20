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

  it 'renders the page kicker' do
    expect(page).to have_content('Manual comparision')
  end

  it 'renders the page heading' do
    expect(page).to have_content('Parent')
  end

  context 'click title of an item' do
    xit 'takes you to single content item page' do
      click_link 'Parent'
      expect(current_path).to eq '/parent'
    end

    xit 'respects the date filter' do
      stub_metrics_page(base_path: 'path/1', time_period: :past_year)
      stub_content_page(time_period: 'past-year', organisation_id: 'org-id', items: items)

      visit "/content?date_range=past-year&organisation_id=org-id"
      click_link 'The title'
      expect(current_path).to eq '/metrics/path/1'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.past-year.leading')}")
    end
  end

  context 'filter by organisation' do
    before do
      stub_content_page(time_period: 'last-month', organisation_id: 'another-org-id', items: items)
      select 'another org', from: 'organisation_id'
      click_on 'Filter'
    end

    xit 'makes request to api with correct organisation_id' do
      expect(page).to have_content('Content data')
    end

    xit 'links to the page data page after filtering' do
      click_on 'The title'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.last-month.leading')}")
    end

    xit 'selected organisation is shown in dropdown menu' do
      expect(page).to have_select('organisation_id', selected: 'another org')
    end

    xit 'describes the filter in the table header' do
      expect(page).to have_css('h1.table-caption', exact_text: 'Showing 3 results for all document types from another org')
    end

    xit 'respects date range' do
      stub_metrics_page(base_path: 'path/1', time_period: :past_year)
      stub_content_page(time_period: 'past-year', organisation_id: 'another-org-id', items: items)

      visit "/content?date_range=past-year&organisation_id=another-org-id"

      select 'another org', from: 'organisation_id'
      click_on 'Filter'
      click_on 'The title'
      expect(page).to have_content("Page data: #{I18n.t('metrics.show.time_periods.past-year.leading')}")
    end

    context 'with no organisations' do
      before do
        stub_content_page(
          time_period: 'past-30-days',
          organisation_id: 'users-org-id',
          items: items
        )
        stub_content_page(
          time_period: 'past-30-days',
          organisation_id: 'none',
          items: [items[0].merge(title: 'Content with no primary org')]
        )
        visit '/content?date_range=past-30-days&organisation_id=users-org-id'
        select('No primary organisation', from: 'organisation_id')
        click_on 'Filter'
      end

      xit 'shows the data no primary organisation' do
        expect(page.status_code).to eq(200)
        expect(page).to have_content('Content with no primary org')
      end
    end
  end

  describe 'no results returned' do
    before do
      stub_content_page(time_period: 'past-3-months', organisation_id: 'org-id', items: [])
      visit "/content?date_range=past-3-months&organisation_id=org-id"
    end

    xit 'shows a no data message in the table header' do
      expect(page).to have_css('h1.table-caption', exact_text: "#{I18n.t 'no_matching_results'} for all document types from org (OI)")
    end
  end

  describe 'large set of results' do
    before do
      stub_content_page(time_period: 'past-3-months', organisation_id: 'org-id', items: items * 50)
      visit "/content?date_range=past-3-months&organisation_id=org-id"
    end

    xit 'formats the page numbers correctly in the table header' do
      expect(page).to have_css('h1.table-caption', exact_text: 'Showing 150 results for all document types from org (OI)')
    end
  end
end
