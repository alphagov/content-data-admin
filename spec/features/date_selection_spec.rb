RSpec.describe 'date selection', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex pdf_count words satisfaction] }

  before do
    initial_page_stub
  end

  it 'renders data for the last 30 days if no date period is selected' do
    date_range = build(:date_range, :last_30_days)
    visit '/metrics/base/path'
    expect_default_date_period_metrics_to_be_displayed(date_range.from.to_date, date_range.to.to_date)
  end

  it 'renders data for the last 30 days when `Past 30 days` is selected' do
    date_range = build(:date_range, :last_30_days)
    stub_response_for_date_range(date_range.from.to_date, date_range.to.to_date)
    visit_page_and_filter_by_date_range('last-30-days')
    expect_metrics_for_each_date_to_be_correct(date_range.from.to_date, date_range.to.to_date)
  end

  it 'renders data for the previous month when `Past month` is selected' do
    date_range = build(:date_range, :last_month)
    stub_response_for_date_range(date_range.from.to_date, date_range.to.to_date)
    visit_page_and_filter_by_date_range('last-month')
    expect_metrics_for_each_date_to_be_correct(date_range.from.to_date, date_range.to.to_date)
  end

  it 'renders data for the last 3 months when `Past 3 months` is selected' do
    date_range = build(:date_range, :last_3_months)
    stub_response_for_date_range(date_range.from.to_date, date_range.to.to_date)
    visit_page_and_filter_by_date_range('last-3-months')
    expect_metrics_for_each_date_to_be_correct(date_range.from.to_date, date_range.to.to_date)
  end

  it 'renders data for the last 6 months when `Past 6 months` is selected' do
    date_range = build(:date_range, :last_6_months)
    stub_response_for_date_range(date_range.from.to_date, date_range.to.to_date)
    visit_page_and_filter_by_date_range('last-6-months')
    expect_metrics_for_each_date_to_be_correct(date_range.from.to_date, date_range.to.to_date)
  end

  it 'renders data for the last year when `Past year` is selected' do
    date_range = build(:date_range, :last_year)
    stub_response_for_date_range(date_range.from.to_date, date_range.to.to_date)
    visit_page_and_filter_by_date_range('last-year')
    expect_metrics_for_each_date_to_be_correct(date_range.from.to_date, date_range.to.to_date)
  end

  it 'renders data for the last 2 years when `Past 2 years` is selected' do
    date_range = build(:date_range, :last_2_years)
    stub_response_for_date_range(date_range.from.to_date, date_range.to.to_date)
    visit_page_and_filter_by_date_range('last-2-years')
    expect_metrics_for_each_date_to_be_correct(date_range.from.to_date, date_range.to.to_date)
  end

  def initial_page_stub
    from = Time.zone.today - 30.days
    to = Time.zone.today
    content_data_api_has_single_page(base_path: 'base/path',
                                     from: from.to_s,
                                     to: to.to_s)
    content_data_api_has_metric(base_path: 'base/path',
                                from: from,
                                to: to,
                                metrics: metrics)
    content_data_api_has_timeseries(base_path: 'base/path',
                                    from: from,
                                    to: to,
                                    metrics: metrics,
                                    payload: {
       upviews: [
         { "date" => (from - 1.day).to_s, "value" => 0 },
         { "date" => (from - 2.days).to_s, "value" => 9 },
         { "date" => (to + 1.day).to_s, "value" => 9 }
       ],
       pviews: [
         { "date" => (from - 1.day).to_s, "value" => 8 },
         { "date" => (from - 2.days).to_s, "value" => 8 },
         { "date" => (to + 1.day).to_s, "value" => 8 }
       ],
       searches: [
         { "date" => (from - 1.day).to_s, "value" => 8 },
         { "date" => (from - 2.days).to_s, "value" => 8 },
         { "date" => (to + 1.day).to_s, "value" => 8 }
       ],
       satisfaction: [
         { "date" => (from - 1.day).to_s, "value" => 100 },
         { "date" => (from - 2.days).to_s, "value" => 90 },
         { "date" => (to + 1.day).to_s, "value" => 80 }
       ]
     })
  end

  def stub_response_for_date_range(from, to)
    content_data_api_has_metric(base_path: 'base/path',
      from: from,
      to: to,
      metrics: metrics)
    content_data_api_has_timeseries(base_path: 'base/path',
      from: from,
      to: to,
      metrics: metrics)
    content_data_api_has_single_page(base_path: 'base/path',
      from: from.to_s,
      to: to.to_s)
  end

  def expect_metrics_for_each_date_to_be_correct(from, to)
    month_and_date_string_for_date1 = (from - 1.day).to_s.last(5)
    month_and_date_string_for_date2 = (from - 2.days).to_s.last(5)
    month_and_date_string_for_date3 = (to + 1.day).to_s.last(5)
    upviews_rows = extract_table_content("#upviews_table")
    expect(upviews_rows).to match_array([
      ['', month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
      ['Unique pageviews', "1", "2", "30"]
    ])
  end

  def expect_default_date_period_metrics_to_be_displayed(from, to)
    month_and_date_string_for_date1 = (from - 1.day).to_s.last(5)
    month_and_date_string_for_date2 = (from - 2.days).to_s.last(5)
    month_and_date_string_for_date3 = (to + 1.day).to_s.last(5)
    upviews_rows = extract_table_content("#upviews_table")
    expect(upviews_rows).to match_array([
      ['', month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
      ['Unique pageviews', "1", "2", "30"]
    ])
  end

  def visit_page_and_filter_by_date_range(date_range)
    visit '/metrics/base/path'
    find("input[type=radio][name=date_range][value=#{date_range}]").click
    click_button 'Change dates'
  end
end
