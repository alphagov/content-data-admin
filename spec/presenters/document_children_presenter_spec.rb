RSpec.describe DocumentChildrenPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:parent_document_type) { 'Manual' }
  let(:documents) do
    [
      { title: 'Parent', document_type: parent_document_type },
      { title: 'Child1' },
      { title: 'Child2' }
    ]
  end

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

  describe '#kicker' do
    context 'when the parent is a manual' do
      it 'returns manual kicker' do
        expect(subject.kicker).to eq('Manual comparision')
      end
    end
  end

  describe '#content_items' do
    it 'return parent followed by children' do
      expect(subject.content_items).to eq(%w(Parent Child1 Child2))
    end
  end
end
