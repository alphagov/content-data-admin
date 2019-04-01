RSpec.describe FilterPresenter do
  let(:document_types) do
    [{ id: 'case_study', name: 'Case study' },
     { id: 'guide', name: 'Guide' },
     { id: 'news_story', name: 'News story' },
     { id: 'html_publication', name: 'HTML publication' }]
  end
  let(:organisations) do
    [{ name: 'org', id: 'org-id', acronym: 'OI', },
     { name: 'another org', id: 'another-org-id', },
     { name: 'Users Org', id: 'users-org-id', acronym: 'UOI', }]
  end
  let(:search_parameters) do
    {
      document_type: 'news_story',
      organisation_id: 'org-id'
    }
  end

  before do
    allow(FetchDocumentTypes).to receive(:call).and_return(document_types: document_types)
    allow(FetchOrganisations).to receive(:call).and_return(organisations: organisations)
  end

  subject do
    FilterPresenter.new search_parameters
  end

  describe '#document_type_options' do
    it 'formats the document types for the options component' do
      expect(subject.document_type_options).to eq([
        ["", "all"],
        ["All document types", "all"],
        ["Case study", "case_study"],
        %w(Guide guide),
        ["News story", "news_story"],
        ["HTML publication", "html_publication"]
      ])
    end
  end

  describe '#organisation_options' do
    it 'formats the organisations for the options component' do
      expect(subject.organisation_options).to eq([
        ["", "all"],
        ["All organisations", "all"],
        ["No primary organisation", "none"],
        ["org (OI)", "org-id"],
        ["another org", "another-org-id"],
        ["Users Org (UOI)", "users-org-id"]
      ])
    end
  end

  describe '#document_type?' do
    context 'when valid document type in parameter' do
      it 'returns true' do
        expect(subject.document_type?).to eq(true)
      end
    end

    context 'when no document type in parameter' do
      before { search_parameters[:document_type] = '' }
      it 'returns false' do
        expect(subject.document_type?).to eq(false)
      end
    end
  end

  describe '#document_type_name' do
    it 'returns the formatted document type' do
      expect(subject.document_type_name).to eq("News story")
    end
  end

  describe '#organisation_name' do
    it 'returns the selected organisation name' do
      expect(subject.organisation_name).to eq('org (OI)')
    end
  end
end
