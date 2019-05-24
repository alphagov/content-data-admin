RSpec.describe '/metrics/base/path', type: :feature do
  include RequestStubs
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex words pdf_count satisfaction useful_yes useful_no reading_time] }
  let(:prev_from) { Time.zone.yesterday - 59.days }
  let(:prev_to) { Time.zone.yesterday - 30.days }
  let(:from) { Time.zone.yesterday - 29.days }
  let(:to) { Time.zone.yesterday }

  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  context 'when the page we are requesting is the homepage' do
    before do
      GDS::SSO.test_user = build(:user)
      stub_metrics_page(base_path: nil, time_period: :last_month)
      visit '/metrics?date_range=last-month'
    end

    it 'renders the page without errors' do
      expect(page.status_code).to eq(200)
    end
  end

  context 'when the page has no edition metrics' do
    before do
      GDS::SSO.test_user = build(:user)
      stub_metrics_page(base_path: nil, time_period: :last_month, edition_metrics_missing: true)
      visit '/metrics?date_range=last-month'
    end

    it 'renders the page without errors' do
      expect(page.status_code).to eq(200)
    end

    it 'does not display reading time' do
      label = 'About reading time'
      expect(page).to_not have_selector("metric-summary__reading-time .govuk-details__summary-text", text: label)
    end
  end

  context 'successful request' do
    before do
      GDS::SSO.test_user = build(:user)
      stub_metrics_page(base_path: 'base/path', time_period: :past_30_days)
      visit '/metrics/base/path'
    end

    describe 'metadata section' do
      it 'renders the metadata' do
        metadata = find('.page-metadata').all('tr').map do |el|
          el.all('th,td').map(&:text)
        end
        expect(metadata).to eq([
                                [I18n.t("components.metadata.labels.publishing_organisation"), 'The Ministry'],
                                [I18n.t("components.metadata.labels.document_type"), 'News story'],
                                [I18n.t("components.metadata.labels.base_path"), 'gov.uk/base/path']
                               ])
      end
    end

    describe 'glance metrics section' do
      it 'renders glance metrics unique page views' do
        expect(page).to have_selector '.glance-metric.upviews', text: '6k'
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

      it 'renders glance metric context for on page searches' do
        expect(page).to have_selector '.glance-metric.searches', text: '4.05%'
      end

      it 'renders trend percentage for page searches' do
        expect(page).to have_selector '.searches .app-c-glance-metric__trend', text: '3,950.00%'
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
      let(:expected_table_dates) { ['', '25 Nov 2018', '26 Nov 2018', '24 Dec 2018'] }

      it 'renders the metric for upviews' do
        expect(page).to have_selector '.metric-summary__upviews', text: '6,000'
      end

      it 'renders about label for upviews' do
        label = 'About unique pageviews'
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
        label = 'About pageviews'
        expect(page).to have_selector(".metric-summary__pviews .govuk-details__summary-text", text: label)
      end

      it 'renders a metric for satisfaction' do
        expect(page).to have_selector '.metric-summary__satisfaction', text: '90%'
      end

      it 'renders about label for satisfaction' do
        label = "About 'users who found page useful'"
        expect(page).to have_selector(".metric-summary__satisfaction .govuk-details__summary-text", text: label)
      end

      it 'renders the total number of responses as context for satisfaction score' do
        expect(page).to have_selector '.metric-summary__satisfaction .app-c-info-metric__short-context', text: '700 responses'
      end

      it 'renders a metric for feedex' do
        expect(page).to have_selector '.metric-summary__feedex', text: '63'
      end

      it 'renders about label for feedex' do
        label = 'About number of feedback comments'
        expect(page).to have_selector(".metric-summary__feedex .govuk-details__summary-text", text: label)
      end

      it 'renders link to feedback explorer' do
        expect(page).to have_selector('.govuk-link', text: I18n.t("metrics.feedex.external_link"))
      end

      it 'renders a metric for pdf_count' do
        expect(page).to have_selector '.metric-summary__pdf-count', text: '3'
      end

      it 'renders about label for pdf count' do
        label = 'About number of PDFs'
        expect(page).to have_selector(".metric-summary__pdf-count .govuk-details__summary-text", text: label)
      end

      it 'renders a metric for word count' do
        expect(page).to have_selector '.metric-summary__words', text: '200'
      end

      it 'renders about label for word count' do
        label = 'About word count'
        expect(page).to have_selector(".metric-summary__words .govuk-details__summary-text", text: label)
      end

      it 'renders a metric for time to read' do
        expect(page).to have_selector '.metric-summary__reading-time', text: '200'
      end

      it 'renders about label for time to read' do
        label = 'About reading time'
        expect(page).to have_selector(".metric-summary__reading-time .govuk-details__summary-text", text: label)
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
          ["Searches from page", "80", "80", "83"]
        ])
      end

      it 'renders link to search terms' do
        expect(page).to have_selector('.govuk-link', text: I18n.t("metrics.searches.external_link"))
      end

      it 'renders the satisfaction score' do
        within '.section-performance' do
          expect(page).to have_selector('.metric-summary__satisfaction', text: '90% (700 responses) +50.00%')
        end
      end

      it 'renders the metric timeseries for ' do
        feedback_comment_rows = extract_table_content(".chart.feedex table")

        expect(feedback_comment_rows).to match_array([
          expected_table_dates,
          ["Number of feedback comments", "20", "21", "22"]
        ])
      end
    end

    context 'when the data-api has no comparison data' do
      it 'returns trend as `no comparison data`' do
        stub_metrics_page(
          base_path: 'base/path',
          time_period: 'past_30_days',
          comparision_data_missing: true
        )

        visit '/metrics/base/path'
        expect(page.status_code).to eq(200)
        expect(page).to have_selector '.upviews .app-c-glance-metric__trend', text: 'no comparison data'
      end
    end

    context 'when the data-api has an error' do
      it 'returns a 404 for a Gds::NotFound' do
        stub_metrics_page(
          base_path: 'base/path',
          time_period: 'past_30_days',
          content_item_missing: true
        )

        visit '/metrics/base/path'
        expect(page.status_code).to eq(404)
        expect(page).to have_content "Page not found"
      end
    end

    context 'no time series from the data-api' do
      before do
        stub_metrics_page(
          base_path: 'base/path',
          time_period: 'past_30_days',
          current_data_missing: true,
          comparision_data_missing: true
        )

        visit '/metrics/base/path'
      end

      xit 'renders a div to indicate no data when empty' do
        expect(page).not_to have_content('Unique pageviews table')
        expect(page).to have_selector 'div',
                                      text: 'No Unique pageviews data for the selected time period'
      end
    end

    describe 'related actions' do
      it 'renders the publishing application' do
        expect(page).to have_selector '.related-actions', text: 'Whitehall'
      end

      it 'renders the contacts application' do
        stub_metrics_page(base_path: 'contacts/path', time_period: :past_30_days, publishing_app: 'contacts')
        visit '/metrics/contacts/path'
        label = I18n.t("metrics.show.navigation.edit_link", publishing_app: 'Contacts')
        expect(page).to have_link(label, href: 'http://contacts-admin.dev.gov.uk/admin/contacts/path/edit')
      end

      it 'renders the specialist publisher application' do
        stub_metrics_page(base_path: 'specialist/path', time_period: :past_30_days, publishing_app: 'specialist-publisher')
        visit '/metrics/specialist/path'
        label = I18n.t("metrics.show.navigation.edit_link", publishing_app: 'Specialist publisher')
        expect(page).to have_link(label, href: "http://specialist-publisher.dev.gov.uk/news-storys/content-id/edit")
      end

      it 'renders the collections application' do
        stub_metrics_page(base_path: 'collections/path', time_period: :past_30_days, publishing_app: 'collections-publisher')
        visit '/metrics/collections/path'
        label = I18n.t("metrics.show.navigation.request_change_link")
        expect(page).to have_link(label, href: 'http://support.dev.gov.uk/content_change_request/new')
      end

      it 'renders the travel advice application' do
        stub_metrics_page(base_path: 'travel/path', time_period: :past_30_days, publishing_app: 'travel-advice-publisher')
        visit '/metrics/travel/path'
        label = I18n.t("metrics.show.navigation.edit_link", publishing_app: 'Travel advice publisher')
        expect(page).to have_link(label, href: 'http://travel-advice-publisher.dev.gov.uk/admin/countries/path')
      end
    end
  end
end
