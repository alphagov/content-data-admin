RSpec.describe Calculator::AverageSearchesPerUser do
  subject { Calculator::AverageSearchesPerUser }

  it "returns 0 if there are 0 searches" do
    expect(subject.calculate(searches: 0, unique_pageviews: 10)).to eq 0
  end

  it "returns 0 if there are 0 unique pageviews" do
    expect(subject.calculate(searches: 10, unique_pageviews: 0)).to eq 0
  end

  it "returns average searches per user" do
    expect(subject.calculate(searches: 10, unique_pageviews: 20)).to eq 50
  end
end
