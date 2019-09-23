RSpec.describe Calculator::PageviewsPerVisit do
  subject { Calculator::PageviewsPerVisit }

  it "returns 0 if there are 0 pageviews" do
    expect(subject.calculate(pageviews: 0, unique_pageviews: 10)).to eq 0
  end

  it "returns 0 if there are 0 unique pageviews" do
    expect(subject.calculate(pageviews: 10, unique_pageviews: 0)).to eq 0
  end

  it "returns nil if there are nil pageviews" do
    expect(subject.calculate(pageviews: nil, unique_pageviews: 10)).to eq nil
  end

  it "returns nil if there are nil unique pageviews" do
    expect(subject.calculate(pageviews: 10, unique_pageviews: nil)).to eq nil
  end

  it "returns pageviews per visit if there are pageviews and unique pageviews" do
    expect(subject.calculate(pageviews: 100, unique_pageviews: 10)).to eq 10
  end
end
