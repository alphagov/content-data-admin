RSpec.describe ContentItemsPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:document_types) { default_document_types }
  let(:organisations) { default_organisations }
  let(:search_parameters) do
    {
      date_range: 'last-30-days',
      organisation_id: 'org-id',
      document_type: 'news_story'
    }
  end
  let(:content_items) do
    {
      results: [],
      total_results: 300,
      total_pages: 3,
      page: 1
    }
  end

  around do |example|
    Timecop.freeze Date.new(2018, 6, 1) do
      example.run
    end
  end

  subject do
    ContentItemsPresenter.new(content_items, search_parameters, document_types, organisations)
  end

  describe '#document_type_options' do
    context 'when valid document type in parameter' do
      it 'formats the document types for the options component' do
        expect(subject.document_type_options).to eq([
          { text: 'All document types', value: '', selected: false },
          { text: 'Case study', value: 'case_study', selected: false },
          { text: 'Guide', value: 'guide', selected: false },
          { text: 'News story', value: 'news_story', selected: true }
        ])
      end
    end

    context 'when no document type in parameter' do
      before { search_parameters[:document_type] = '' }
      it 'formats the document types for the options component' do
        expect(subject.document_type_options).to eq([
          { text: 'All document types', value: '', selected: true },
          { text: 'Case study', value: 'case_study', selected: false },
          { text: 'Guide', value: 'guide', selected: false },
          { text: 'News story', value: 'news_story', selected: false }
        ])
      end
    end
  end

  describe '#organisation_options' do
    context 'when valid organisation id in parameter' do
      it 'formats the organisations for the options component' do
        expect(subject.organisation_options).to eq([
          { text: 'org', value: 'org-id', selected: true },
          { text: 'another org', value: 'another-org-id', selected: false }
        ])
      end
    end
  end

  describe '#prev_link?' do
    it 'returns false if on first page' do
      expect(subject.prev_link?).to eq(false)
    end

    it 'returns true if on another page' do
      content_items[:page] = 2
      expect(subject.prev_link?).to eq(true)
    end
  end

  describe '#prev_label' do
    it 'returns the correct page numbers' do
      content_items[:page] = 2
      expect(subject.prev_label).to eq('1 of 3')
    end
  end

  describe '#next_link?' do
    it 'returns false when on the last page' do
      content_items[:page] = 3
      expect(subject.next_link?).to eq(false)
    end

    it 'returns true when on the another page' do
      expect(subject.next_link?).to eq(true)
    end
  end
end
