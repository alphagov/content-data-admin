RSpec.describe SingleContentItemPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:date_range) { build(:date_range, :last_30_days) }
  let(:current_period_data) { default_single_page_payload('the/base/path', '2018-11-25', '2018-12-25') }
  let(:previous_period_data) { default_single_page_payload('the/base/path', '2018-10-26', '2018-11-25') }


  subject do
    SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)
  end

  describe '#publishing_app' do
    it 'does not fail if no publishing app' do
      current_period_data[:metadata][:publishing_app] = nil

      expect(subject.publishing_app).to eq('Unknown')
    end

    it 'capitalizes the publishing_app if present' do
      expect(subject.publishing_app).to eq('Publisher')
    end
  end

  describe '#trend_percentage' do
    it 'calculates an increase percentage change' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]
      previous_period_data[:time_series_metrics] = [{ name: 'upviews', total: 50 }]

      expect(subject.trend_percentage('upviews')).to eq(100.0)
    end

    it 'calculates an decrease percentage change' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 50 }]
      previous_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]

      expect(subject.trend_percentage('upviews')).to eq(-50.0)
    end

    it 'calculates an no percentage change' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]
      previous_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }]

      expect(subject.trend_percentage('upviews')).to eq(0.0)
    end
  end

  describe '#metadata' do
    it 'returns a hash with the metadata' do
      expect(subject.base_path).to eq('/the/base/path')
      expect(subject.published_at).to eq("17 July 2018")
      expect(subject.last_updated).to eq("17 July 2018")
      expect(subject.document_type).to eq("News story")
      expect(subject.publishing_organisation).to eq("The Ministry")
    end

    it 'returns the title' do
      expect(subject.title).to eq('Content Title')
    end
  end
end
