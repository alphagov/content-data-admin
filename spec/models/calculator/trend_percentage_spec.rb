RSpec.describe Calculator::TrendPercentage do
  subject { Calculator::TrendPercentage }
  it 'returns 0 if previous value <= 0' do
    expect(subject.calculate(1, 0)).to eq 0
  end

  it 'returns trend percentage if previous value > 0' do
    expect(subject.calculate(2, 1)).to eq 100
  end
end
