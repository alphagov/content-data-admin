RSpec.feature 'user analytics' do
  include RequestStubs
  before do
    stub_metrics_page(base_path: nil, time_period: :past_30_days)
    visit '/metrics?date_range=past-30-days'
  end

  scenario 'tracks back link button' do
    expect(page).to have_selector('[data-gtm-id="back-link"]')
  end

  scenario 'tracks the top of the page visability' do
    expect(page).to have_selector('[data-gtm-id="page-kicker"]')
  end

  scenario 'tracks view table reveal section' do
    expect(page).to have_selector('[data-gtm-id="view-table-reveal"]')
  end

  scenario 'tracks time period submit' do
    expect(page).to have_selector('[data-gtm-id="time-period-form"]')
  end

  scenario 'tracks glance metrics section' do
    expect(page).to have_selector('[data-gtm-id="glance-metrics"]')
  end

  scenario 'tracks metric section headings' do
    expect(page).to have_selector('[data-gtm-id="metric-section-heading"]')
  end

  scenario 'tracks metric "about this data" reveal' do
    expect(page).to have_selector('[data-gtm-id="metric-summary"] summary')
  end

  scenario 'tracks content metrics reveal' do
    expect(page).to have_selector('[data-gtm-id="content-metrics"] summary')
  end

  scenario 'tracks clicks on app name in header' do
    expect(page).to have_selector('.govuk-phase-banner__content__app-name')
  end
end
