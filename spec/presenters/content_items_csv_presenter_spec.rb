RSpec.describe ContentItemsCSVPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:document_types) { default_document_types }
  let(:organisations) { default_organisations }
  let(:search_params) do
    {
      date_range: 'past-30-days',
      organisation_id: 'org-id',
      document_type: 'news_story'
    }
  end
  let(:data_enum) do
    [
      {
        title: 'GOV.UK homepage',
        base_path: '/',
  organisation_id: 'none',
        document_type: 'homepage',
        upviews: 15,
        satisfaction_score_responses: 2,
        searches: 14
      },
      {
        title: 'Title 1',
        base_path: '/base-path-1',
  organisation_id: 'another-org-id',
        document_type: 'guide',
        upviews: 15,
        satisfaction_score_responses: 2,
        searches: 14
      }
    ]
  end

  subject do
    described_class.new(data_enum, search_params, document_types, organisations)
  end

  describe 'CSV headers' do
    expected_headers = [
      'Title',
      'Organisation',
      'URL',
      'Content Data Link',
      'Document Type',
      I18n.t('metrics.upviews.short_title'),
      I18n.t('metrics.satisfaction.short_title'),
      'User satisfaction score responses',
      I18n.t('metrics.searches.short_title'),
      'Link to feedback comments'
    ]
    expected_headers.each do |header_name|
      it "contains #{header_name}" do
        expect(subject.csv_rows.first).to include(header_name)
      end
    end
  end

  describe '#csv_rows' do
    it 'returns the right number of rows' do
      expect(subject.csv_rows.to_a.length).to eq(3)
    end

    it 'correctly generates data rows' do
      data_row = subject.csv_rows.to_a[1]

      expect(CSV.parse_line(data_row).length).to be(10)
      expect(data_row).to include('2')
    end

    it 'the organisation' do
      data_row = subject.csv_rows.to_a

      expect(CSV.parse_line(data_row[1])[1]).to eq('No organisation')
      expect(CSV.parse_line(data_row[2])[1]).to eq('another org')
    end
  end

  describe '#filename' do
    it 'includes the organisation and document_type' do
      expect(
        subject.filename
      ).to include('from-org-in-news-story.csv')
    end
  end

  context 'when `All Organisations` is selected' do
    subject { described_class.new(data_enum, search_params.merge(organisation_id: 'all'), document_types, organisations) }

    it 'includes all-organisations in filename' do
      expect(
        subject.filename
      ).to include('from-all-organisations-in-news-story.csv')
    end
  end

  context 'when `No primary organisation` is selected' do
    subject { described_class.new(data_enum, search_params.merge(organisation_id: 'none'), document_types, organisations) }

    it 'includes no-organisation in filename' do
      expect(
        subject.filename
      ).to include('from-no-organisation-in-news-story.csv')
    end
  end
end
