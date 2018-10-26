RSpec.describe SingleContentItemPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:date_range) { build(:date_range, :last_30_days) }
  let(:current_period_data) { default_single_page_payload('the/base/path', '2018-11-25', '2018-12-25') }
  let(:previous_period_data) { default_single_page_payload('the/base/path', '2018-10-26', '2018-11-25') }


  around do |example|
    Timecop.freeze Date.new(2018, 6, 1) do
      example.run
    end
  end

  subject do
    SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)
  end

  describe '#trend_percentage' do
    it 'calculates an increase percentage change' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]
      previous_period_data[:time_series_metrics] = [{ name: 'upviews', total: 50 }]

      expect(subject.trend_percentage('upviews')).to eq(100.0)
    end

    it 'calculates an decrease percentage change' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 50 }]
      previous_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]

      expect(subject.trend_percentage('upviews')).to eq(-50.0)
    end

    it 'calculates an no percentage change' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]
      previous_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]

      expect(subject.trend_percentage('upviews')).to eq(0.0)
    end

    it 'calculates an infinite percent increase (0 to non-zero)' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]
      previous_period_data[:time_series_metrics] = [{ name: 'upviews', total: 0 }]

      expect(subject.trend_percentage('upviews')).to eq(0.0)
    end
  end

  describe '#searches_context' do
    it 'shows the percentage of users who searched the page' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'searches', total: 10 }]
      expect(subject.searches_context).to eq "10.0% of users searched from the page"
    end

    it 'return 0 if there are no unique pageviews' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 0 }, { name: 'searches', total: 10 }]
      expect(subject.searches_context).to eq "0% of users searched from the page"
    end

    it 'returns 0 if there have been no searches' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 10 }, { name: 'searches', total: 0 }]
      expect(subject.searches_context).to eq "0% of users searched from the page"
    end

    it 'rounds to 2 decimal places' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 8777 }, { name: 'searches', total: 1753 }]
      expect(subject.searches_context).to eq "19.97% of users searched from the page"
    end

    it 'caps to a maximum of 100%' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'searches', total: 900 }]
      expect(subject.searches_context).to eq "100% of users searched from the page"
    end
  end

  describe '#metadata' do
    it 'returns a hash with the metadata' do
      expect(subject.base_path).to eq('/the/base/path')
      expect(subject.published_at).to eq("17 July 2018")
      expect(subject.last_updated).to eq("17 July 2018")
      expect(subject.document_type).to eq("News story")
      expect(subject.publishing_organisation).to eq("The Ministry")
    end

    it 'returns the title' do
      expect(subject.title).to eq('Content Title')
    end
  end

  describe '#feedback_explorer_href' do
    it 'returns a URI for the feedback explorer' do
      host = Plek.new.external_url_for('support')
      expected_link = "#{host}/anonymous_feedback?from=2018-05-02&to=2018-06-01&paths=%2Fthe%2Fbase%2Fpath"
      expect(subject.feedback_explorer_href).to eq(expected_link)
    end
  end

  describe '#edit_url' do
    it 'uses the ExternalLinksHelper' do
      allow_any_instance_of(ExternalLinksHelper).to receive(
        :edit_url_for
      ).with(
        content_id: 'content-id',
        publishing_app: 'whitehall'
      ).and_return(
        'https://expected-link'
      )

      expect(subject.edit_url).to eq('https://expected-link')
    end
  end

  describe '#edit_label' do
    it 'uses the ExternalLinksHelper' do
      allow_any_instance_of(ExternalLinksHelper).to receive(
        :edit_label_for
      ).with(
        publishing_app: 'whitehall'
      ).and_return(
        'expected-label'
      )

      expect(subject.edit_label).to eq('expected-label')
    end
  end

  describe '#link_text' do
    it 'returns the downcased translation of the metric name' do
      expect(subject.link_text('upviews')).to eq('unique pageviews')
    end
  end
end
