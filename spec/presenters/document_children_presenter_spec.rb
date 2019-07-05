RSpec.describe DocumentChildrenPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:parent_document_type) { 'Manual' }
  let(:documents) do
    [
      {
        title: 'Parent',
        base_path: '/parent',
        document_type: parent_document_type
      },
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
    DocumentChildrenPresenter.new(documents, '/parent')
  end

  before do
    allow(ContentRowPresenter).to receive(:new) { |d| d[:title] }
  end

  describe '#kicker' do
    context 'when the parent is a manual' do
      it 'returns manual kicker' do
        expect(subject.kicker).to eq('Manual comparison')
      end
    end
  end

  describe '#header' do
    it 'return the page heading' do
      expect(subject.header).to eq('Parent')
    end

    context 'when travel advice with single colon' do
      let(:documents) { [{ title: 'Parent: overview', document_type: 'travel_advice', base_path: '/parent' }] }
      it 'return base of the title' do
        expect(subject.header).to eq('Parent')
      end
    end

    context 'when guide with single colon' do
      let(:documents) { [{ title: 'Parent: overview', document_type: 'guide', base_path: '/parent' }] }
      it 'return base of the title' do
        expect(subject.header).to eq('Parent')
      end
    end

    context 'when guide with multiple colons' do
      let(:documents) { [{ title: 'Parent: topic: overview', document_type: 'guide', base_path: '/parent' }] }
      it 'removed section from last colon from title' do
        expect(subject.header).to eq('Parent: topic')
      end
    end
  end

  describe '#title' do
    it 'return the page title' do
      expect(subject.title).to eq('Parent: Manual comparison')
    end
  end

  describe '#content_items' do
    it 'return parent followed by children' do
      expect(subject.content_items).to eq(%w(Parent Child1 Child2))
    end
  end
end
