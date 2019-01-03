RSpec.describe CustomMetricsHelper do
  describe 'pageviews_per_visit' do
    it 'returns 0 if there are 0 pageviews' do
      expect(calculate_pageviews_per_visit(pageviews: 0, unique_pageviews: 10)).to eq 0
    end

    it 'returns 0 if there are 0 unique pageviews' do
      expect(calculate_pageviews_per_visit(pageviews: 10, unique_pageviews: 0)).to eq 0
    end

    it 'returns nil if there are nil pageviews' do
      expect(calculate_pageviews_per_visit(pageviews: nil, unique_pageviews: 10)).to eq nil
    end

    it 'returns nil if there are nil unique pageviews' do
      expect(calculate_pageviews_per_visit(pageviews: 10, unique_pageviews: nil)).to eq nil
    end

    it 'returns pageviews per visit if there are pageviews and unique pageviews' do
      expect(calculate_pageviews_per_visit(pageviews: 100, unique_pageviews: 10)).to eq 10
    end
  end

  describe 'average_searches_per_user' do
    it 'returns 0 if there are 0 searches' do
      expect(calculate_average_searches_per_user(searches: 0, unique_pageviews: 10)).to eq 0
    end

    it 'returns 0 if there are 0 unique pageviews' do
      expect(calculate_average_searches_per_user(searches: 10, unique_pageviews: 0)).to eq 0
    end

    it 'returns average searches per user' do
      expect(calculate_average_searches_per_user(searches: 10, unique_pageviews: 20)).to eq 50
    end
  end
end
