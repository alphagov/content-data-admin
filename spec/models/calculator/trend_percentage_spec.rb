RSpec.describe Calculator::TrendPercentage do
  subject { Calculator::TrendPercentage }
  it 'returns 0 if previous value <= 0' do
    expect(subject.new(1, 0).run).to eq 0
  end

  it 'returns trend percentage if previous value > 0' do
    expect(subject.new(2, 1).run).to eq 100
  end
end
