RSpec.describe '/metrics/base/path', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  let(:metrics) { MetricsService::DEFAULT_METRICS }
  context 'successful request' do
    before do
      content_data_api_has_metric(base_path: 'base/path',
        from: '2000-01-01',
        to: '2050-01-01',
        metrics: metrics,
        payload: {
          base_path: '/base/path',
          unique_pageviews: 145_000,
          pageviews: 200_000,
          title: "Content Title",
          first_published_at: '2018-02-01T00:00:00.000Z',
          public_updated_at: '2018-04-25T00:00:00.000Z',
          primary_organisation_title: 'The ministry',
          document_type: "news_story",
          number_of_internal_searches: 250,
          satisfaction_score: 25.5
        })

      content_data_api_has_timeseries(base_path: 'base/path',
        from: '2000-01-01',
        to: '2050-01-01',
        metrics: metrics,
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
          ],
          number_of_internal_searches: [
            { "date" => "2018-01-13", "value" => 5 },
            { "date" => "2018-01-14", "value" => 12 },
            { "date" => "2018-01-15", "value" => 10 }
          ],
          satisfaction_score: [
            { "date" => "2018-01-13", "value" => 30.3 },
            { "date" => "2018-01-14", "value" => 20.3 },
            { "date" => "2018-01-15", "value" => 40.1 }
          ]
        })
      visit '/metrics/base/path?from=2000-01-01&to=2050-01-01'
    end

    it 'renders the metric for unique_pageviews' do
      expect(page).to have_content('145000')
    end

    it 'renders the metric for pageviews' do
      expect(page).to have_content('200000')
    end

    it 'renders a metric for satisfaction_score' do
      expect(page).to have_content('25.5')
    end

    it 'renders the page title' do
      expect(page).to have_content('Content Title')
    end

    it 'renders a metric for on page searches' do
      expect(page).to have_content('250')
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

      expect(unique_pageviews_rows.count).to eq 4
      expect(unique_pageviews_rows[0].text).to eq ''
      expect(unique_pageviews_rows[1].text).to eq '01-13 101'
      expect(unique_pageviews_rows[2].text).to eq '01-14 202'
      expect(unique_pageviews_rows[3].text).to eq '01-15 303'
    end

    it 'renders the metric timeseries for pageviews' do
      click_on 'Pageviews table'
      pageviews_rows = find("#pageviews_2018-01-13-2018-01-15_table").all('tr')

      expect(pageviews_rows.count).to eq 4
      expect(pageviews_rows[0].text).to eq ''
      expect(pageviews_rows[1].text).to eq '01-13 10'
      expect(pageviews_rows[2].text).to eq '01-14 20'
      expect(pageviews_rows[3].text).to eq '01-15 30'
    end

    it 'renders the metric timeseries for on-page searches' do
      click_on 'Number of internal searches table'
      internal_searches_rows = find("#number_of_internal_searches_2018-01-13-2018-01-15_table").all('tr')

      expect(internal_searches_rows.count).to eq 4
      expect(internal_searches_rows[0].text).to eq ''
      expect(internal_searches_rows[1].text).to eq '01-13 5'
      expect(internal_searches_rows[2].text).to eq '01-14 12'
      expect(internal_searches_rows[3].text).to eq '01-15 10'
    end

    it 'renders the metric timeseries for satisfaction_score' do
      click_on 'Number of internal searches table'
      satisfaction_score_rows = find("#satisfaction_score_2018-01-13-2018-01-15_table").all('tr')

      expect(satisfaction_score_rows.count).to eq 4
      expect(satisfaction_score_rows[0].text).to eq ''
      expect(satisfaction_score_rows[1].text).to eq '01-13 30.3'
      expect(satisfaction_score_rows[2].text).to eq '01-14 20.3'
      expect(satisfaction_score_rows[3].text).to eq '01-15 40.1'
    end
  end

  context 'when the data-api has an error' do
    it 'returns a 404 for a Gds::NotFound' do
      content_data_api_does_not_have_base_path(base_path: 'base/path',
        from: '2000-01-01',
        to: '2050-01-01',
        metrics: metrics)
      visit '/metrics/base/path?from=2000-01-01&to=2050-01-01'
      expect(page.status_code).to eq(404)
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end
end
