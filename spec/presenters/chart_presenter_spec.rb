RSpec.describe ChartPresenter do
  include ActiveSupport::Testing::TimeHelpers

  let(:date_range) { build :date_range, :last_30_days }

  around do |example|
    Timecop.freeze Date.new(2018, 1, 31) do
      example.run
    end
  end

  subject do
    ChartPresenter.new(
      json:
        [
          { date: '2018-01-13', value: 101 },
          { date: '2018-01-14', value: 202 },
          { date: '2018-01-15', value: 303 }
        ],
      metric: :upviews,
      date_range: date_range,
    )
  end

  it 'returns start date' do
    expect(subject.from).to eq '2017-12-31'
  end
  it 'returns end date' do
    expect(subject.to).to eq '2018-01-30'
  end

  it 'returns the correct message for no data' do
    expect(subject.no_data_message).to eq 'No Unique pageviews data for the selected time period'
  end

  it 'returns formatted hash of chart data padded with nils' do
    expect(subject.chart_data).to eq upviews_chart_data
  end

  def upviews_chart_data
    expected_keys = (subject.from.to_date..subject.to.to_date).map do |date|
      date.strftime("%m-%d")
    end
    expected_values = Array.new(13) + [101, 202, 303] + Array.new(15)
    {
      caption: "Unique pageviews from 2017-12-31 to 2018-01-30",
      chart_id: "upviews_chart",
      chart_label: "Unique pageviews",
      keys: expected_keys,

      rows: [
        {
          label: "Unique pageviews ",
          values: expected_values
        }
      ],
      table_id: "upviews_table",
      table_direction: "vertical"
    }
  end
end
