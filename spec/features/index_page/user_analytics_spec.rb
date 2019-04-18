RSpec.feature 'user analytics' do
  include RequestStubs
  before do
    stub_content_page(time_period: 'past-30-days', organisation_id: 'all')
    visit '/content'
  end

  scenario 'tracks filter form submit' do
    expect(page).to have_selector('[data-gtm-id="filters-form"]')
  end

  scenario 'tracks total number of results' do
    expect(page).to have_selector('[data-gtm-total-results]')
  end

  scenario 'tracks total number of results (old way)' do
    expect(page).to have_selector('[data-gtm-pagination-total-results]')
  end

  scenario 'tracks prev and next pagination links' do
    expect(page).to have_selector('[data-gtm-id="pagination-links"]')
  end

  scenario 'tracks content item page links' do
    expect(page).to have_selector('[data-gtm-id="content-item-link"][data-gtm-item-document-type]')
  end

  scenario 'tracks content item page links (old way)' do
    expect(page).to have_selector('[data-gtm-id="content-item-link"][data-gtm]')
  end

  help_icon_columns = %w(upviews satisfaction searches)

  help_icon_columns.each do |column|
    scenario "tracks help icon for #{column} in table headers" do
      expect(page).to have_selector("[data-gtm-id=\"#{column}-column\"] [data-gtm-id=\"help-icon\"]")
    end
  end

  sortable_columns = %w(document_type upviews satisfaction searches)
  sortable_columns.each do |column|
    scenario "tracks sort link for #{column}" do
      expect(page).to have_selector("[data-gtm-id=\"#{column}-column\"] [data-gtm-id=\"sort-link\"]")
    end
  end

  scenario 'tracks table header' do
    expect(page).to have_selector('[data-gtm-id="table-header"]')
  end

  scenario 'tracks CSV download link' do
    expect(page).to have_selector('[data-gtm-id="csv-download-link"]')
  end

  # scenario 'tracks time period reveal' do
  #   expect(page).to have_selector('[data-gtm-id="time-period-options"] summary')
  # end

  scenario 'tracks clicks on app name in header' do
    expect(page).to have_selector('.govuk-phase-banner__content__app-name')
  end
end
