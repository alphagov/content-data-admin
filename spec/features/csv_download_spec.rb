RSpec.describe 'csv download', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:date1) { Date.yesterday.strftime }
  let(:date2) { (Time.zone.today - 1.month).strftime }
  let(:date3) { (Date.tomorrow - 1.month).strftime }

  before do
    GDS::SSO.test_user = build(:user)
    stub_metrics_page(base_path: 'base/path', time_period: :past_30_days)

    visit '/csv-metrics/base/path'
    content_data_api_has_csv(columns: %w(Date Value), values: [['10-10-2018', 1000], ['11-10-2018', 1100]])
  end

  it 'downloads csv' do
    visit '/metrics/base/path?date_range=past-30-days'
    click_link 'Download Unique pageviews CSV'
    expect(CSV.parse(page.body)).to eq [%w(Date Value), [date2, "1000"], [date3, "2000"], [date1, "3000"]]
  end
end
