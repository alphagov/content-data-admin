RSpec.describe 'date selection', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:base_path) { 'base/path' }
  let(:page_uri) { "/metrics/#{base_path}" }

  before do
    Timecop.freeze(Date.new(2018, 12, 25))
    GDS::SSO.test_user = build(:user)
    # Stub backend API for initial page visit
    stub_metrics_page(base_path: base_path, time_period: :past_30_days)
  end

  after do
    Timecop.return
  end

  context 'no date period provided' do
    it 'renders the correct date ranges in the time select' do
      visit page_uri
      time_labels = find('.app-c-time-select').all('.govuk-radios__item').map do |el|
        { el.find('label').text => el.find('span').text }
      end
      expect(time_labels).to match([
        { I18n.t('metrics.show.time_periods.past-30-days.leading') => "25 November 2018 to 24 December 2018" },
        { I18n.t('metrics.show.time_periods.last-month.leading') => "1 November 2018 to 30 November 2018" },
        { I18n.t('metrics.show.time_periods.past-3-months.leading') => "25 September 2018 to 24 December 2018" },
        { I18n.t('metrics.show.time_periods.past-6-months.leading') => "25 June 2018 to 24 December 2018" },
        { I18n.t('metrics.show.time_periods.past-year.leading') => "25 December 2017 to 24 December 2018" },
        { I18n.t('metrics.show.time_periods.past-2-years.leading') => "25 December 2016 to 24 December 2018" },
      ])
    end

    it 'renders data for the past 30 days' do
      visit page_uri
      expect_upviews_table_to_contain_dates(['25 Nov 2018', '26 Nov 2018', '24 Dec 2018'])
    end
  end

  it 'renders data for the past 30 days when `Past 30 days` is selected' do
    visit_page_and_filter_by_date_range('past-30-days')
    expect_upviews_table_to_contain_dates(['25 Nov 2018', '26 Nov 2018', '24 Dec 2018'])
  end

  it 'renders data for the previous month when `Past month` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :last_month)
    visit_page_and_filter_by_date_range('last-month')
    expect_upviews_table_to_contain_dates(['1 Nov 2018', '2 Nov 2018', '30 Nov 2018'])
  end

  it 'renders data for the past 3 months when `Past 3 months` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :past_3_months)
    visit_page_and_filter_by_date_range('past-3-months')
    expect_upviews_table_to_contain_dates(['25 Sep 2018', '26 Sep 2018', '24 Dec 2018'])
  end

  it 'renders data for the past 6 months when `Past 6 months` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :past_6_months)
    visit_page_and_filter_by_date_range('past-6-months')
    expect_upviews_table_to_contain_dates(['25 Jun 2018', '26 Jun 2018', '24 Dec 2018'])
  end

  it 'renders data for the past year when `Past year` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :past_year)
    visit_page_and_filter_by_date_range('past-year')
    expect_upviews_table_to_contain_dates(['25 Dec 2017', '26 Dec 2017', '24 Dec 2018'])
  end

  it 'renders data for the past 2 years when `Past 2 years` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :past_2_years)
    visit_page_and_filter_by_date_range('past-2-years')
    expect_upviews_table_to_contain_dates(['25 Dec 2016', '26 Dec 2016', '24 Dec 2018'])
  end

  def visit_page_and_filter_by_date_range(date_range)
    visit page_uri
    find("input[type=radio][name=date_range][value=#{date_range}]").click
    click_button 'Change dates'
  end

  def expect_upviews_table_to_contain_dates(dates)
    upviews_rows = extract_table_content("#upviews_table")
    expect(upviews_rows).to include([''] + dates)
  end
end
