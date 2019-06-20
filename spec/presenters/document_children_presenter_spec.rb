RSpec.describe DocumentChildrenPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:documents) { [{ title: 'Parent' }, { title: 'Child1' }, { title: 'Child2' }] }

  around do |example|
    Timecop.freeze Date.new(2018, 6, 1) do
      example.run
    end
  end

  subject do
    DocumentChildrenPresenter.new(documents)
  end

  before do
    allow(ContentRowPresenter).to receive(:new) { |d| d[:title] }
  end

  describe '#title' do
    it 'returns Page title' do
      expect(subject.title).to eq('Comparision')
    end
  end

  describe '#content_items' do
    it 'return parent followed by children' do
      expect(subject.content_items).to eq(%w(Parent Child1 Child2))
    end
  end
end
