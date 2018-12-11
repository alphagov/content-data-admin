RSpec.describe MetricsCSVPresenter do
  let(:time_series) do
    [
      { date: '01-01-2018', value: 1000 },
      { date: '01-02-2018', value: 2000 },
      { date: '01-03-2018', value: 3000 }
    ]
  end
  subject { MetricsCSVPresenter.new(time_series, '/base/path', 'upviews') }

  it 'generates a csv' do
    expect(subject.csv_rows).to eq "Date,Value\n01-01-2018,1000\n01-02-2018,2000\n01-03-2018,3000\n"
  end

  it 'generates a file name' do
    expect(subject.filename).to eq "#{Time.zone.today.strftime}_Unique pageviews_/base/path"
  end
end
