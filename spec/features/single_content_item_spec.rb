RSpec.describe '/metrics/base/path', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex words pdf_count satisfaction useful_yes useful_no] }
  let(:prev_from) { Time.zone.today - 60.days }
  let(:from) { Time.zone.today - 30.days }
  let(:to) { Time.zone.today }

  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  context 'successful request' do
    before do
      GDS::SSO.test_user = build(:user)
      stub_metrics_page(base_path: 'base/path', time_period: :last_30_days)
      visit '/metrics/base/path'
    end

    describe 'metadata section' do
      it 'renders the metadata' do
        metadata = find('.page-metadata').all('dl').map do |el|
          el.all('dt,dd').map(&:text)
        end
        expect(metadata).to eq([
                                 [I18n.t("components.metadata.labels.published_at"), '17 July 2018',
                                  I18n.t("components.metadata.labels.last_updated"), '17 July 2018'],
                                 [I18n.t("components.metadata.labels.publishing_organisation"), 'The Ministry',
                                  I18n.t("components.metadata.labels.document_type"), 'News story',
                                  I18n.t("components.metadata.labels.base_path"), 'gov.uk/base/path']
                               ])
      end
    end

    describe 'glance metrics section' do
      it 'renders glance metrics unique page views' do
        expect(page).to have_selector '.glance-metric.upviews', text: '6,000'
      end

      it 'renders glance metric context for unique pageviews' do
        expect(page).to have_selector '.glance-metric.upviews', text: '2.74%'
      end

      it 'renders trend percentage for unique pageviews' do
        expect(page).to have_selector '.upviews .app-c-glance-metric__trend', text: '+500.00%'
      end

      it 'renders glance metric for satisfaction score' do
        expect(page).to have_selector '.glance-metric.satisfaction', text: '90%'
      end

      it 'renders glance metric context for satisfaction score' do
        expect(page).to have_selector '.glance-metric.satisfaction', text: '700'
      end

      it 'renders trend percentage for satisfaction score' do
        expect(page).to have_selector '.satisfaction .app-c-glance-metric__trend', text: '+50.00%'
      end

      it 'renders glance metric for on page searches' do
        expect(page).to have_selector '.glance-metric.searches', text: '24'
      end

      xit 'renders glance metric context for on page searches' do
        expect(page).to have_selector '.glance-metric.searches', text: '50%'
      end

      it 'renders trend percentage for page searches' do
        expect(page).to have_selector '.searches .app-c-glance-metric__trend', text: '406.25%'
      end

      it 'renders glance metric for feedex comments' do
        expect(page).to have_selector '.glance-metric.feedex', text: '63'
      end

      it 'renders trend percentage for feedex comments' do
        expect(page).to have_selector '.feedex .app-c-glance-metric__trend', text: '+5.00%'
      end

      it 'renders context for page searches' do
        expect(page).to have_selector '.searches .app-c-glance-metric__context', text: '4.05%'
      end
    end

    describe 'page metric section' do
      let(:expected_table_dates) { ['', '11-25', '11-26', '12-25'] }

      it 'renders the metric for upviews' do
        expect(page).to have_selector '.metric-summary__upviews', text: '6,000'
      end

      it 'renders about label for upviews' do
        label = expected_metric_label('upviews')
        expect(page).to have_selector(".metric-summary__upviews .govuk-details__summary-text", text: label)
        expect(page).to have_selector '.metric-summary__upviews', text: '6,000'
      end

      it 'renders the metric for pviews' do
        expect(page).to have_selector '.metric-summary__pviews', text: '60,000'
      end

      it 'renders the metric for pagviews per visit' do
        expect(page).to have_selector '.metric-summary__pageviews_per_visit', text: '10.0'
      end

      it 'renders about label for pviews' do
        label = expected_metric_label('pviews')
        expect(page).to have_selector(".metric-summary__pviews .govuk-details__summary-text", text: label)
      end

      it 'renders a metric for satisfaction' do
        expect(page).to have_selector '.metric-summary__satisfaction', text: '90%'
      end

      it 'renders about label for satisfaction' do
        label = expected_metric_label('satisfaction')
        expect(page).to have_selector(".metric-summary__satisfaction .govuk-details__summary-text", text: label)
      end

      it 'renders the total number of responses as context for satisfaction score' do
        expect(page).to have_selector '.metric-summary__satisfaction .app-c-info-metric__short-context', text: '700 responses'
      end

      it 'renders a metric for feedex' do
        expect(page).to have_selector '.metric-summary__feedex', text: '63'
      end

      it 'renders about label for feedex' do
        label = expected_metric_label('feedex')
        expect(page).to have_selector(".metric-summary__feedex .govuk-details__summary-text", text: label)
      end

      it 'renders link to feedback explorer' do
        expect(page).to have_selector('.govuk-link', text: I18n.t("metrics.feedex.external_link"))
      end

      it 'renders a metric for pdf_count' do
        expect(page).to have_selector '.metric-summary__pdf-count', text: '3'
      end

      it 'renders about label for pdf count' do
        label = expected_metric_label('pdf_count')
        expect(page).to have_selector(".metric-summary__pdf-count .govuk-details__summary-text", text: label)
      end

      it 'renders a metric for words count' do
        expect(page).to have_selector '.metric-summary__words', text: '200'
      end

      it 'renders about label for  words count' do
        label = expected_metric_label('words')
        expect(page).to have_selector(".metric-summary__words .govuk-details__summary-text", text: label)
      end

      it 'renders the page title' do
        expect(page).to have_selector 'h1.govuk-heading-xl', text: 'Content Title'
      end

      it 'renders a metric for on page searches' do
        expect(page).to have_selector '.metric-summary__searches', text: '24'
      end

      it 'renders a page searches metric as a percentage of views' do
        expect(page).to have_selector '.govuk-grid-column-one-quarter.searches', text: '24'
      end

      it 'renders the metric timeseries for upviews' do
        upviews_rows = extract_table_content(".chart.upviews table")
        expect(upviews_rows).to match_array([
          expected_table_dates,
          ["Unique pageviews", "1,000", "2,000", "3,000"]
        ])
      end

      it 'renders the metric timeseries for pviews' do
        pviews_rows = extract_table_content(".chart.pviews table")
        expect(pviews_rows).to match_array([
          expected_table_dates,
          %w[Pageviews 10,000 20,000 30,000]
        ])
      end

      it 'renders the metric timeseries for on-page searches' do
        internal_searches_rows = extract_table_content(".chart.searches table")
        expect(internal_searches_rows).to match_array([
          expected_table_dates,
          ["Searches from the page", "80", "80", "83"]
        ])
      end

      it 'renders the metric timeseries for satisfaction' do
        satisfaction_rows = extract_table_content(".chart.satisfaction table")
        expect(satisfaction_rows).to match_array([
          expected_table_dates,
          ["User satisfaction score", "100.000%", "90.000%", "80.000%"]
        ])
      end

      it 'renders the metric timeseries for ' do
        feedback_comment_rows = extract_table_content(".chart.feedex table")

        expect(feedback_comment_rows).to match_array([
          expected_table_dates,
          ["Number of feedback comments", "20", "21", "22"]
        ])
      end
    end

    context 'when the data-api has an error' do
      it 'returns a 404 for a Gds::NotFound' do
        content_data_api_does_not_have_base_path(base_path: 'base/path',
                                                 from: from.to_s,
                                                 to: to.to_s)
        visit '/metrics/base/path'
        expect(page.status_code).to eq(404)
        expect(page).to have_content "The page you were looking for doesn't exist."
      end
    end

    context 'no time series from the data-api' do
      before do
        content_data_api_has_single_page_missing_data(base_path: 'base/path', from: from.to_s, to: to.to_s)
        content_data_api_has_single_page_missing_data(base_path: 'base/path', from: prev_from.to_s, to: from.to_s)
        visit '/metrics/base/path'
      end

      it 'renders a div to indicate no data when empty' do
        expect(page).not_to have_content('Unique pageviews table')
        expect(page).to have_selector 'div',
                                      text: 'No Unique pageviews data for the selected time period'
      end
    end

    describe 'related actions' do
      it 'renders the publishing application' do
        expect(page).to have_selector '.related-actions', text: 'Whitehall'
      end
    end
  end
end

def expected_metric_label(metric_name)
  short_title = I18n.t("metrics.#{metric_name}.short_title").downcase
  I18n.t("components.info-metric.about_dropdown", metric_short_title: short_title)
end
