RSpec.describe PaginationPresenter do
  subject do
    PaginationPresenter.new(
      page: page,
      total_pages: 11,
      per_page: 10,
      total_results: 105
    )
  end

  context 'when on the first page' do
    let(:page) { 1 }

    it 'returns false from #prev_link?' do
      expect(subject.prev_link?).to eq(false)
    end

    it 'returns true from #next_link?' do
      expect(subject.next_link?).to eq(true)
    end

    it 'return the correct next page label' do
      expect(subject.next_label).to eq('2 of 11')
    end
  end

  context 'when on the last page' do
    let(:page) { 11 }

    it 'returns true from #prev_link?' do
      expect(subject.prev_link?).to eq(true)
    end

    it 'returns false from #next_link?' do
      expect(subject.next_link?).to eq(false)
    end

    it 'returns the correct next page label' do
      expect(subject.prev_label).to eq('10 of 11')
    end
  end

  context 'when somewhere in the middle' do
    let(:page) { 6 }

    it 'returns true from #prev_link?' do
      expect(subject.prev_link?).to eq(true)
    end

    it 'returns true from #prev_link?' do
      expect(subject.prev_link?).to eq(true)
    end

    it 'returns the correct next page label' do
      expect(subject.prev_label).to eq('5 of 11')
    end

    it 'return the correct next page label' do
      expect(subject.next_label).to eq('7 of 11')
    end
  end
end
