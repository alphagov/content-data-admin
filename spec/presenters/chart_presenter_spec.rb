RSpec.describe ChartPresenter do
  subject do
    ChartPresenter.new(
      unique_pageviews: [
         { date: '2018-01-13', value: 101 },
         { date: '2018-01-14', value: 202 },
         { date: '2018-01-15', value: 303 }
      ]
  )
  end

  it 'returns start date' do
    expect(subject.from).to eq '2018-01-13'
  end
  it 'returns end date' do
    expect(subject.to).to eq '2018-01-15'
  end
  it 'returns the metric' do
    expect(subject.metric).to eq 'unique_pageviews'
  end
  it 'returns the metric name in a human readable manner' do
    expect(subject.human_friendly_metric).to eq 'Unique pageviews'
  end
  it 'returns formatted hash of chart data' do
    expect(subject.chart_data).to eq expected_chart_data
  end

  def expected_chart_data
    {
      caption: "Unique pageviews from 2018-01-13 to 2018-01-15",
      chart_id: "unique_pageviews_2018-01-13-2018-01-15_chart",
      chart_label: "Unique pageviews chart",
      keys: [
        "01-13",
        "01-14",
        "01-15"
      ],
      rows: [
        {
          values: [
            101,
            202,
            303
          ]
        }
      ],
      table_id: "unique_pageviews_2018-01-13-2018-01-15_table",
      table_label: "Unique pageviews table"
    }
  end
end
