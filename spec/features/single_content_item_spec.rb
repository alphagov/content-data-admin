RSpec.describe '/metrics/base/path', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  let(:metrics_response) do
    {}
  end

  before do
    content_data_api_has_metric(base_path: 'base/path',
                           from: '2000-01-01',
                           to: '2050-01-01',
                           metrics: %w[unique_pageviews page_views],
                           payload: {
                               unique_pageviews: { total: 145_000 },
                               pageviews: { total: 200_000 }
                           })

    content_data_api_has_timeseries(base_path: 'base/path',
                               from: '2000-01-01',
                               to: '2050-01-01',
                               metrics: %w[unique_pageviews page_views],
                               payload: {
                                 unique_pageviews: [
                                   { "date" => "2018-01-13", "value" => 101 },
                                   { "date" => "2018-01-14", "value" => 202 },
                                   { "date" => "2018-01-15", "value" => 303 }
                                 ],
                                 pageviews: [
                                     { "date" => "2018-01-13", "value" => 10 },
                                     { "date" => "2018-01-14", "value" => 20 },
                                     { "date" => "2018-01-15", "value" => 30 }
                                 ]
                               })

    visit '/metrics/base/path?from=2000-01-01&to=2050-01-01&metrics[]=unique_pageviews&metrics[]=page_views'
  end

  it 'renders the metric for unique_pageviews' do
    expect(page).to have_content('Metrics')
    expect(page).to have_content('145000')
  end

  it 'renders the metric timeseries for unique_pageviews' do
    click_on 'Unique pageviews table'
    unique_pageviews_rows = find("#unique_pageviews_2018-01-13-2018-01-15_table").all('tr')
    pageviews_rows = find("#pageviews_2018-01-13-2018-01-15_table").all('tr')

    expect(unique_pageviews_rows.count).to eq 4
    expect(unique_pageviews_rows[0].text).to eq 'Date'
    expect(unique_pageviews_rows[1].text).to eq '01-13 101'
    expect(unique_pageviews_rows[2].text).to eq '01-14 202'
    expect(unique_pageviews_rows[3].text).to eq '01-15 303'

    expect(pageviews_rows.count).to eq 4
    expect(pageviews_rows[0].text).to eq 'Date'
    expect(pageviews_rows[1].text).to eq '01-13 10'
    expect(pageviews_rows[2].text).to eq '01-14 20'
    expect(pageviews_rows[3].text).to eq '01-15 30'
  end
end
