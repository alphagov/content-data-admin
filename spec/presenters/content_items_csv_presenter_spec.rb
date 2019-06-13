RSpec.describe ContentItemsCSVPresenter do
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
        organisation_id: nil,
        document_type: 'homepage',
        upviews: 15,
        pviews: 25,
        satisfaction: 0.25,
        useful_yes: 100,
        useful_no: 300,
        searches: 14,
        feedex: 24,
        word_count: 50,
        reading_time: 50,
        pdf_count: 0
      },
      {
        title: 'Title 1',
        base_path: '/base-path-1',
        organisation_id: 'another-org-id',
        document_type: 'guide',
        upviews: 15,
        pviews: 25,
        satisfaction: 0.6,
        useful_yes: 300,
        useful_no: 200,
        searches: 14,
        feedex: 24,
        word_count: 100,
        reading_time: 100,
        pdf_count: 3
      }
    ]
  end

  subject do
    described_class.new(data_enum, search_params, document_types, organisations)
  end

  describe '#csv_rows' do
    let(:presenter) { described_class.new(data_enum, search_params, document_types, organisations) }

    subject { CSV.parse(presenter.csv_rows) }

    it 'returns the right number of rows' do
      expect(subject.count).to eq(3)
    end

    describe 'headers' do
      subject { CSV.parse(presenter.csv_rows).first }

      expected_headers = [
        I18n.t('row_headers.title'),
        I18n.t('row_headers.organisation'),
        I18n.t('row_headers.govuk_url'),
        I18n.t('row_headers.content_data_url'),
        I18n.t('row_headers.document_type'),
        I18n.t('metrics.upviews.short_title'),
        I18n.t('metrics.pviews.short_title'),
        I18n.t('metrics.pageviews_per_visit.short_title'),
        I18n.t('metrics.percentage_users_searched.title'),
        I18n.t('metrics.satisfaction.short_title'),
        I18n.t('metrics.useful_yes.title'),
        I18n.t('metrics.useful_no.title'),
        I18n.t('metrics.searches.short_title'),
        I18n.t('metrics.feedex.short_title'),
        I18n.t('row_headers.feedback_explorer_url'),
        I18n.t('metrics.reading_time.short_title'),
        I18n.t('metrics.words.short_title'),
        I18n.t('metrics.pdf_count.short_title')
      ]

      expected_headers.each do |header_name|
        it { is_expected.to include(header_name) }
      end

      it 'returns correct number of columns' do
        expect(subject.length).to be(expected_headers.length)
      end
    end

    describe 'values' do
      subject { CSV.parse(presenter.csv_rows)[1] }

      it 'has a title' do
        expect(subject[0]).to eq('GOV.UK homepage')
      end

      it 'has a organisation' do
        expect(subject[1]).to eq('No organisation')
      end

      it 'has a URL' do
        expect(subject[2]).to start_with('http')
      end

      it 'has a Content Data Link' do
        expect(subject[3]).to eq('http://content-data.dev.gov.uk/metrics')
      end

      it 'has a Document Type' do
        expect(subject[4]).to eq('homepage')
      end

      it 'has upviews' do
        expect(subject[5]).to eq('15')
      end

      it 'has pviews' do
        expect(subject[6]).to eq('25')
      end

      it 'has pageviews per visit' do
        expect(subject[7]).to eq('1.67')
      end

      it 'has searches per user' do
        expect(subject[8]).to eq('93.33%')
      end

      it 'has satisfaction score' do
        expect(subject[9]).to eq('25%')
      end

      it 'has yes responses' do
        expect(subject[10]).to eq('100')
      end

      it 'has no responses' do
        expect(subject[11]).to eq('300')
      end

      it 'has number of searches' do
        expect(subject[12]).to eq('14')
      end

      it 'has number of feedback comments' do
        expect(subject[13]).to eq('24')
      end

      it 'has link to feedback comments' do
        expect(subject[14]).to start_with('http')
      end

      it 'has reading time' do
        expect(subject[15]).to eq('0h 50m')
      end

      it 'has word count' do
        expect(subject[16]).to eq('50')
      end

      it 'has pdf count' do
        expect(subject[17]).to eq('0')
      end
    end
  end

  describe '#filename' do
    it 'includes the organisation and document_type' do
      expect(
        subject.filename
      ).to include('from-org-in-news-story')
    end
  end

  context 'when `All Organisations` is selected' do
    subject { described_class.new(data_enum, search_params.merge(organisation_id: 'all'), document_types, organisations) }

    it 'includes all-organisations in filename' do
      expect(
        subject.filename
      ).to include('from-all-organisations-in-news-story')
    end
  end

  context 'when `No primary organisation` is selected' do
    subject { described_class.new(data_enum, search_params.merge(organisation_id: 'none'), document_types, organisations) }

    it 'includes no-organisation in filename' do
      expect(
        subject.filename
      ).to include('from-no-organisation-in-news-story')
    end
  end
end
