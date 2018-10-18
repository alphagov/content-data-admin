RSpec.describe 'date selection', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:base_path) { 'base/path' }
  let(:page_uri) { "/metrics/#{base_path}" }

  before do
    Timecop.freeze(Date.new(2018, 12, 25))
    # Stub backend API for initial page visit
    stub_metrics_page(base_path: base_path, time_period: :last_30_days)
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
        { I18n.t('metrics.show.time_periods.last-30-days.leading') => "25 November 2018 to 25 December 2018" },
        { I18n.t('metrics.show.time_periods.last-month.leading') => "1 November 2018 to 30 November 2018" },
        { I18n.t('metrics.show.time_periods.last-3-months.leading') => "25 September 2018 to 25 December 2018" },
        { I18n.t('metrics.show.time_periods.last-6-months.leading') => "25 June 2018 to 25 December 2018" },
        { I18n.t('metrics.show.time_periods.last-year.leading') => "25 December 2017 to 25 December 2018" },
        { I18n.t('metrics.show.time_periods.last-2-years.leading') => "25 December 2016 to 25 December 2018" },
      ])
    end

    it 'renders data for the last 30 days' do
      visit page_uri
      expect_metrics_for_each_date_to_be_correct(from: '2018-11-25', to: '2018-12-25')
    end
  end

  it 'renders data for the last 30 days when `Past 30 days` is selected' do
    visit_page_and_filter_by_date_range('last-30-days')
    expect_metrics_for_each_date_to_be_correct(from: '2018-11-25', to: '2018-12-25')
  end

  it 'renders data for the previous month when `Past month` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :last_month)
    visit_page_and_filter_by_date_range('last-month')
    expect_metrics_for_each_date_to_be_correct(from: '2018-11-01', to: '2018-11-30')
  end

  it 'renders data for the last 3 months when `Past 3 months` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :last_3_months)
    visit_page_and_filter_by_date_range('last-3-months')
    expect_metrics_for_each_date_to_be_correct(from: '2018-09-25', to: '2018-12-25')
  end

  it 'renders data for the last 6 months when `Past 6 months` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :last_6_months)
    visit_page_and_filter_by_date_range('last-6-months')
    expect_metrics_for_each_date_to_be_correct(from: '2018-06-25', to: '2018-12-25')
  end

  it 'renders data for the last year when `Past year` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :last_year)
    visit_page_and_filter_by_date_range('last-year')
    expect_metrics_for_each_date_to_be_correct(from: '2017-12-25', to: '2018-12-25')
  end

  it 'renders data for the last 2 years when `Past 2 years` is selected' do
    stub_metrics_page(base_path: base_path, time_period: :last_2_years)
    visit_page_and_filter_by_date_range('last-2-years')
    expect_metrics_for_each_date_to_be_correct(from: '2016-12-25', to: '2018-12-25')
  end

  def visit_page_and_filter_by_date_range(date_range)
    visit page_uri
    find("input[type=radio][name=date_range][value=#{date_range}]").click
    click_button 'Change dates'
  end

  def expect_metrics_for_each_date_to_be_correct(from:, to:)
    from = from.to_date
    to = to.to_date
    month_and_date_string_for_date1 = (from - 1.day).to_s.last(5)
    month_and_date_string_for_date2 = (from - 2.days).to_s.last(5)
    month_and_date_string_for_date3 = (to + 1.day).to_s.last(5)
    upviews_rows = extract_table_content("#upviews_table")
    expect(upviews_rows).to include(
      ['', month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
    )
  end
end
