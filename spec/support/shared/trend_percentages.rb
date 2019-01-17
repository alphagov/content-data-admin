RSpec.shared_examples 'Trend percentages presentation' do
  include GdsApi::TestHelpers::ContentDataApi

  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  let(:date_range) { build(:date_range, :past_30_days) }
  let(:current_period_data) { default_single_page_payload('the/base/path', Date.new(2018, 11, 25), Date.new(2018, 12, 24)) }
  let(:previous_period_data) { default_single_page_payload('the/base/path', Date.new(2018, 10, 26), Date.new(2018, 11, 24)) }

  subject do
    SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)
  end

  describe '#trend_percentage' do
    it 'calculates an increase percentage change' do
      current_period_data[:time_series_metrics] = time_series_metrics(100)
      previous_period_data[:time_series_metrics] = time_series_metrics(50)

      expect(subject.trend_percentage('upviews')).to eq(100.0)
    end

    it 'calculates an decrease percentage change' do
      current_period_data[:time_series_metrics] = time_series_metrics(50)
      previous_period_data[:time_series_metrics] = time_series_metrics(100)

      expect(subject.trend_percentage('upviews')).to eq(-50.0)
    end

    it 'calculates an no percentage change' do
      current_period_data[:time_series_metrics] = time_series_metrics(100)
      previous_period_data[:time_series_metrics] = time_series_metrics(100)

      expect(subject.trend_percentage('upviews')).to eq(0.0)
    end

    it 'calculates an infinite percent increase (0 to non-zero)' do
      current_period_data[:time_series_metrics] = time_series_metrics(100)
      previous_period_data[:time_series_metrics] = time_series_metrics(0)

      expect(subject.trend_percentage('upviews')).to eq(0.0)
    end

    it 'returns `no comparison data` if there is no comparison data' do
      current_period_data[:time_series_metrics] = time_series_metrics(100)
      previous_period_data[:time_series_metrics] = time_series_metrics(nil, nil)

      expect(subject.trend_percentage('upviews')).to eq(nil)
    end

    it 'returns `no comparison data` if there is incomplete comparison data' do
      current_time_series = [{ date: '2018-11-25', value: 100 }, { date: '2018-11-26', value: 100 }]
      previous_time_series = [{ date: '2018-11-24', value: 100 }]

      current_period_data[:time_series_metrics] = time_series_metrics(100, current_time_series)
      previous_period_data[:time_series_metrics] = time_series_metrics(100, previous_time_series)

      expect(subject.trend_percentage('upviews')).to eq(nil)
    end

    context 'selected date range is `past-month`' do
      it 'calculates percentage change if previous month has data for every day in it' do
        date_range = build(:date_range, :last_month)
        current_time_series = complete_current_data
        previous_month_time_series = complete_previous_data

        current_period_data[:time_series_metrics] = time_series_metrics(200, current_time_series)
        previous_period_data[:time_series_metrics] = time_series_metrics(100, previous_month_time_series)

        subject = SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)

        expect(subject.trend_percentage('upviews')).to eq(100.0)
      end

      it 'returns nil if previous month does not have data for every day in it' do
        build(:date_range, :last_month)
        current_time_series = complete_current_data
        previous_month_time_series = incomplete_previous_data

        current_period_data[:time_series_metrics] = time_series_metrics(200, current_time_series)
        previous_period_data[:time_series_metrics] = time_series_metrics(100, previous_month_time_series)

        subject = SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)

        expect(subject.trend_percentage('upviews')).to eq(nil)
      end
    end
  end

  def time_series_metrics(upviews_total = 100, upviews_timeseries = [{ date: '2018-11-25', value: 100 }])
    [
      {
        name: 'upviews',
        total: upviews_total,
        time_series: upviews_timeseries
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
  end

  def complete_current_data
    previous_month_time_series = []
    (1.month.ago.to_date.beginning_of_month..1.month.ago.to_date.end_of_month).each do |date|
      previous_month_time_series << { date: date.strftime, value: 100 }
    end
    previous_month_time_series
  end

  def complete_previous_data
    previous_month_time_series = []
    (2.months.ago.to_date.beginning_of_month..2.months.ago.to_date.end_of_month).each do |date|
      previous_month_time_series << { date: date.strftime, value: 100 }
    end
    previous_month_time_series
  end

  def incomplete_previous_data
    previous_month_time_series = []
    (2.months.ago.to_date.beginning_of_month + 10.days..2.months.ago.to_date.end_of_month).each do |date|
      previous_month_time_series << { date: date.strftime, value: 100 }
    end
    previous_month_time_series
  end
end
