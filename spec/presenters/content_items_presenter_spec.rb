RSpec.describe ContentItemsPresenter do
  let(:date_range) { DateRange.new('last-30-days') }
  describe '#prev_link?' do
    it 'returns false if on first page' do
      presenter = described_class.new([], date_range, 300, 3, 1)
      expect(presenter.prev_link?).to eq(false)
    end

    it 'returns true if on another page' do
      presenter = described_class.new([], date_range, 300, 3, 2)
      expect(presenter.prev_link?).to eq(true)
    end
  end

  describe '#next_link?' do
    it 'returns false when on the last page' do
      presenter = described_class.new([], date_range, 300, 3, 3)
      expect(presenter.next_link?).to eq(false)
    end

    it 'returns true when on the another page' do
      presenter = described_class.new([], date_range, 300, 3, 2)
      expect(presenter.next_link?).to eq(true)
    end
  end
end
