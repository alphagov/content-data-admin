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
        base_path: '/base/path',
        unique_pageviews: 145_000,
        pageviews: 200_000,
        title: "Content Title",
        first_published_at: '2018-02-01T00:00:00.000Z',
        public_updated_at: '2018-04-25T00:00:00.000Z',
        primary_organisation_title: 'The ministry',
        document_type: "news_story"
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
    expect(page).to have_content('145000')
  end

  it 'renders the metric for pageviews' do
    expect(page).to have_content('200000')
  end

  it 'renders the page title' do
    expect(page).to have_content('Content Title')
  end

  it 'renders the metadata' do
    metadata = find('.page-metadata').all('.metadata-row').map do |el|
      el.all('.metadata-label,.metadata-value').map(&:text)
    end
    expect(metadata).to eq([
      ['Published', '1 February 2018'],
      ['Last updated', '25 April 2018'],
      ['From', 'The ministry'],
      ['Type', 'News story'],
      ['URL', '/base/path']
    ])
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
