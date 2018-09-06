RSpec.describe '/metrics/base/path', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  let(:metrics_response) do
    {}
  end

  before do
    content_data_api_has_metric('base/path',
                           'unique_pageviews',
                           '2000-01-01',
                           '2050-01-01',
                           unique_pageviews: 145_000)
    content_data_api_has_timeseries('base/path',
                               'unique_pageviews',
                               '2000-01-01',
                               '2050-01-01',
                               unique_pageviews: [
                                 { date: '2018-01-13', value: 101 },
                                 { date: '2018-01-14', value: 202 },
                                 { date: '2018-01-15', value: 303 }
                               ])
    visit '/metrics/unique_pageviews/base/path?from=2000-01-01&to=2050-01-01'
  end

  it 'renders the metric for unique_pageviews' do
    expect(page).to have_content('Metrics')
    expect(page).to have_content('145000')
  end

  it 'renders the metric timeseries for unique_pageviews' do
    click_on 'Unique pageviews table'
    rows = all('table tr')
    expect(rows.count).to eq 4
    expect(rows[0].text).to eq 'Date'
    expect(rows[1].text).to eq '01-13 101'
    expect(rows[2].text).to eq '01-14 202'
    expect(rows[3].text).to eq '01-15 303'
  end
end
