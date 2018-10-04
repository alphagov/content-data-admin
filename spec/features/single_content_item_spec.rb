RSpec.describe '/metrics/base/path', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  include TableDataSpecHelpers
  let(:metrics) { %w[pviews upviews searches feedex words pdf_count satisfaction] }
  let(:from) { Time.zone.today - 30.days }
  let(:to) { Time.zone.today }
  let(:month_and_date_string_for_date1) { (from - 1.day).to_s.last(5) }
  let(:month_and_date_string_for_date2) { (from - 2.days).to_s.last(5) }
  let(:month_and_date_string_for_date3) { (to + 1.day).to_s.last(5) }

  context 'successful request' do
    before do
      content_data_api_has_metric(base_path: 'base/path',
        from: from.to_s,
        to: to.to_s,
        metrics: metrics)

      content_data_api_has_timeseries(base_path: 'base/path',
        from: from.to_s,
        to: to.to_s,
        metrics: metrics)
      visit '/metrics/base/path'
    end

    it 'renders the metric for unique_pageviews' do
      expect(page).to have_selector '.metric_summary.unique_pageviews', text: '145,000'
    end

    it 'renders the metric for pageviews' do
      expect(page).to have_selector '.metric_summary.pageviews', text: '200,000'
    end

    it 'renders a metric for satisfaction_score' do
      expect(page).to have_selector '.metric_summary.satisfaction_score', text: '26'
    end

    it 'renders a metric for number_of_feedback_comments' do
      expect(page).to have_selector '.metric_summary.number_of_feedback_comments', text: '20'
    end

    it 'renders a metric for number_of_pdfs' do
      expect(page).to have_selector '.metric_summary.number_of_pdfs', text: '3'
    end

    it 'renders a metric for word_count' do
      expect(page).to have_selector '.metric_summary.word_count', text: '200'
    end

    it 'renders the page title' do
      expect(page).to have_selector 'h1.govuk-heading-xl', text: 'Content Title'
    end

    it 'renders a metric for on page searches' do
      expect(page).to have_selector '.metric_summary.number_of_internal_searches', text: '250'
    end

    it 'renders the publishing application' do
      expect(page).to have_selector '.related-actions', text: 'Whitehall'
    end

    it 'renders the metadata' do
      metadata = find('.page-metadata').all('dl').map do |el|
        el.all('dt,dd').map(&:text)
      end
      expect(metadata).to eq([
        [I18n.t("components.metadata.labels.published_at"), '1 February 2018',
         I18n.t("components.metadata.labels.last_updated"), '25 April 2018'],
        [I18n.t("components.metadata.labels.publishing_organisation"), 'The ministry',
         I18n.t("components.metadata.labels.document_type"), 'News story',
         I18n.t("components.metadata.labels.base_path"), '/.../path']
      ])
    end

    it 'renders the metric timeseries for unique_pageviews' do
      unique_pageviews_rows = extract_table_content(".chart.unique_pageviews table")
      expect(unique_pageviews_rows).to match_array([
        ["", month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
        ["Unique pageviews", "1", "2", "30"]
      ])
    end

    it 'renders the metric timeseries for pageviews' do
      pageviews_rows = extract_table_content(".chart.pageviews table")
      expect(pageviews_rows).to match_array([
        ["", month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
        %w[Pageviews 10 20 30]
      ])
    end

    it 'renders the metric timeseries for on-page searches' do
      internal_searches_rows = extract_table_content(".chart.number_of_internal_searches table")
      expect(internal_searches_rows).to match_array([
        ["", month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
        ["Number of internal searches", "8", "8", "8"]
      ])
    end

    it 'renders the metric timeseries for satisfaction_score' do
      satisfaction_score_rows = extract_table_content(".chart.satisfaction_score table")
      expect(satisfaction_score_rows).to match_array([
        ["", month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
        ["Satisfaction score", "100.000%", "90.000%", "80.000%"]
      ])
    end

    it 'renders the metric timeseries for ' do
      feedback_comment_rows = extract_table_content(".chart.feedex_comments table")

      expect(feedback_comment_rows).to match_array([
        ["", month_and_date_string_for_date1.to_s, month_and_date_string_for_date2.to_s, month_and_date_string_for_date3.to_s],
        ["Feedex comments", "20", "21", "22"]
      ])
    end
  end

  context 'when the data-api has an error' do
    it 'returns a 404 for a Gds::NotFound' do
      content_data_api_does_not_have_base_path(base_path: 'base/path',
        from: from.to_s,
        to: to.to_s,
        metrics: metrics)
      visit '/metrics/base/path'
      expect(page.status_code).to eq(404)
      expect(page).to have_content "The page you were looking for doesn't exist."
    end
  end

  context 'no time series from the data-api' do
    before do
      content_data_api_has_metric(base_path: 'base/path',
        from: from.to_s,
        to: to.to_s,
        metrics: metrics)

      content_data_api_has_timeseries(base_path: 'base/path',
        from: from.to_s,
        to: to.to_s,
        metrics: metrics,
        payload: {
          unique_pageviews: [],
        })
      visit '/metrics/base/path'
    end

    it 'renders a div to indicate no data when empty' do
      expect(page).not_to have_content('Unique pageviews table')
      expect(page).to have_selector 'div',
        text: 'No Unique pageviews data for the selected time period'
    end

    it 'renders a div to indicate no data when missing' do
      expect(page).not_to have_content('Pageviews table')
      expect(page).to have_selector 'div',
        text: 'No Pageviews data for the selected time period'
    end
  end
end
