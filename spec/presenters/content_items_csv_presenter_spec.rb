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
        title: 'Title 1',
        base_path: '/base-path-1',
        doucment_type: 'guide',
        upviews: 15,
        satisfaction_score_responses: 2,
        searches: 14
      },
      {
        title: 'Title 1',
        base_path: '/base-path-1',
        doucment_type: 'guide',
        upviews: 15,
        satisfaction_score_responses: 2,
        searches: 14
      }
    ]
  end

  subject do
    described_class.new(data_enum, search_params, document_types, organisations)
  end

  describe '#csv_rows' do
    it 'returns the right number of rows' do
      expect(subject.csv_rows.to_a.length).to eq(3)
    end

    it 'correctly generates the header' do
      header = subject.csv_rows.first

      expect(header).to include('Document Type')
    end

    it 'correctly generates data rows' do
      data_row = subject.csv_rows.to_a[1]

      expect(CSV.parse_line(data_row).length).to be(9)
      expect(data_row).to include('2')
    end
  end
end
