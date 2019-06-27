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

  describe '#header' do
    it 'return the page heading' do
      expect(subject.header).to eq('Parent')
    end

    context 'when guide with single colon' do
      let(:documents) { [{ title: 'Parent: overview', document_type: 'guide' }] }
      it 'return base of the title' do
        expect(subject.header).to eq('Parent')
      end
    end

    context 'when guide with multiple colons' do
      let(:documents) { [{ title: 'Parent: topic: overview', document_type: 'guide' }] }
      it 'removed section from last colon from title' do
        expect(subject.header).to eq('Parent: topic')
      end
    end
  end

  describe '#title' do
    it 'return the page title' do
      expect(subject.title).to eq('Parent: Manual comparision')
    end
  end

  describe '#content_items' do
    it 'return parent followed by children' do
      expect(subject.content_items).to eq(%w(Parent Child1 Child2))
    end
  end
end
