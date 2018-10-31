RSpec.describe ContentItemsPresenter do
  let(:search_parameters) { { date_range: 'last-30-days' } }
  let(:response) do
    {
      results: [],
      total_results: 300,
      total_pages: 3,
      page: 1
    }
  end
  describe '#prev_link?' do
    it 'returns false if on first page' do
      presenter = described_class.new(response, search_parameters)
      expect(presenter.prev_link?).to eq(false)
    end

    it 'returns true if on another page' do
      presenter = described_class.new(response.merge(page: 2), search_parameters)
      expect(presenter.prev_link?).to eq(true)
    end
  end

  describe '#next_link?' do
    it 'returns false when on the last page' do
      presenter = described_class.new(response.merge(page: 3), search_parameters)
      expect(presenter.next_link?).to eq(false)
    end

    it 'returns true when on the another page' do
      presenter = described_class.new(response, search_parameters)
      expect(presenter.next_link?).to eq(true)
    end
  end
end
