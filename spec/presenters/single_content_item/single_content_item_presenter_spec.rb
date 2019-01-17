RSpec.describe SingleContentItemPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  let(:date_range) { build(:date_range, :past_30_days) }
  let(:current_period_data) { default_single_page_payload('the/base/path', Date.new(2018, 11, 25), Date.new(2018, 12, 24)) }
  let(:previous_period_data) { default_single_page_payload('the/base/path', Date.new(2018, 10, 26), Date.new(2018, 11, 24)) }
  let(:default_timeseries_metrics) {
    [
      {
        name: 'upviews',
        total: 100,
        time_series: [
          {
            date: '2018-11-25',
            value: 100
          }
        ]
      },
      {
        name: 'pviews',
        total: 100,
        time_series: [
          {
            date: '2018-11-25',
            value: 100
          }
        ]
      }
    ]
  }

  subject do
    SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)
  end

  it_behaves_like 'Metadata presentation'
  it_behaves_like 'Trend percentages presentation'

  describe '#status' do
    context 'when content is published' do
      it 'displays nothing' do
        expect(subject.status).to be_nil
      end
    end
    context 'when content is historical' do
      before { current_period_data[:metadata][:historical] = true }
      it 'displays history mode' do
        expect(subject.status).to eq(I18n.t('components.metadata.statuses.historical'))
      end
    end
    context 'when content is withdrawn' do
      before { current_period_data[:metadata][:withdrawn] = true }
      it 'displays withdrawn' do
        expect(subject.status).to eq(I18n.t('components.metadata.statuses.withdrawn'))
      end
    end
    context 'when content is withdrawn and historical' do
      before {
        current_period_data[:metadata][:historical] = true
        current_period_data[:metadata][:withdrawn] = true
      }
      it 'displays withdrawn and history mode' do
        expect(subject.status).to eq(I18n.t('components.metadata.statuses.withdrawn_and_historical'))
      end
    end
  end

  describe '#searches_context' do
    it 'shows the percentage of users who searched the page' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'searches', total: 10 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "10.0% of users searched from the page"
    end

    it 'return 0 if there are no unique pageviews' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 0 }, { name: 'searches', total: 10 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "0% of users searched from the page"
    end

    it 'returns 0 if there have been no searches' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 10 }, { name: 'searches', total: 0 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "0% of users searched from the page"
    end

    it 'rounds to 2 decimal places' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 8777 }, { name: 'searches', total: 1753 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "19.97% of users searched from the page"
    end

    it 'caps to a maximum of 100%' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'searches', total: 900 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "100% of users searched from the page"
    end
  end

  describe '#pageviews_per_visit' do
    it 'calculates number of times the page was viewed in one visit' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 50 }, { name: 'pviews', total: 100 }]
      expect(subject.pageviews_per_visit).to eq('2.0')
    end

    it 'return 0 if there are no pageviews' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'pviews', total: 0 }]
      expect(subject.pageviews_per_visit).to eq('0')
    end

    it 'return 0 if there are no unique pageviews' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 0 }, { name: 'pviews', total: 100 }]
      expect(subject.pageviews_per_visit).to eq('0')
    end

    it 'rounds to 2 decimal places' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 4 }, { name: 'pviews', total: 13 }]
      expect(subject.pageviews_per_visit).to eq('3.25')
    end
  end

  describe '#link_text' do
    it 'returns the downcased translation of the metric name' do
      expect(subject.link_text('upviews')).to eq('unique pageviews')
    end
  end
end
