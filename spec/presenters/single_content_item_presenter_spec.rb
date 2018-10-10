RSpec.describe SingleContentItemPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:from) { '2018-01-01' }
  let(:to) { '2018-06-01' }

  let(:metrics) do
    {
        title: 'The title',
        base_path: '/the/base/path',
        primary_organisation_title: 'UK Visas and Immigration',
        first_published_at: '2016-09-01T00:00:00.000Z',
        public_updated_at: '2017-10-01T00:00:00.000Z',
        document_type: 'news_story',
        upviews: 2030,
        pviews: 3000,
        satisfaction: 33.5,
        searches: 120,
        feedex: 20,
    }
  end
  let(:time_series) { default_timeseries_payload(from.to_date, to.to_date) }
  let(:date_range) { build(:date_range, :last_30_days) }

  subject do
    SingleContentItemPresenter.new(metrics,
      time_series,
      date_range)
  end


  describe '#publishing_app' do
    it 'does not fail if no publishing app' do
      metrics[:publishing_app] = nil

      expect(subject.publishing_app).to eq('Unknown')
    end

    it 'capitalizes the publishing_app if present' do
      metrics[:publishing_app] = 'travel-advice'

      expect(subject.publishing_app).to eq('Travel advice')
    end
  end

  describe '#metadata' do
    it 'returns a hash with the metadata' do
      expect(subject.metadata).to eq(
        base_path: '/the/base/path',
        published_at: "1 September 2016",
        last_updated: "1 October 2017",
        publishing_organisation: 'UK Visas and Immigration',
        document_type: "News story",
      )
    end
  end


  # it 'returns the aggregated metrics' do
  #   expect(subject).to have_attributes(
  #     upviews: 2030,
  #     pviews: 3000,
  #     searches: 120,
  #     feedex: 20,
  #     satisfaction: '34%'
  #   )
  # end

  it 'returns the title' do
    expect(subject.title).to eq('The title')
  end
end
