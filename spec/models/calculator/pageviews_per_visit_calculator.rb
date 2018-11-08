RSpec.describe Calculator::PageviewsPerVisit do
  let(:subject) { Calculator::PageviewsPerVisit }
  context '#current' do
    it 'returns 0 if there are 0 pageviews' do
      metrics = build_metrics(pviews: 0)
      expect(subject.new(metrics).current_period).to eq 0
    end

    it 'returns 0 if there are 0 unique pageviews' do
      metrics = build_metrics(upviews: 0)
      expect(subject.new(metrics).current_period).to eq 0
    end

    it 'returns 0 if there are nil pageviews' do
      metrics = build_metrics(pviews: nil)
      expect(subject.new(metrics).current_period).to eq 0
    end

    it 'returns 0 if there are nil unique pageviews' do
      metrics = build_metrics(upviews: nil)
      expect(subject.new(metrics).current_period).to eq 0
    end

    it 'returns pageviews per visit if there are pageviews and unique pageviews' do
      metrics = build_metrics(pviews: 100, upviews: 10)
      expect(subject.new(metrics).current_period).to eq 10
    end
  end

  context '#previous' do
    it 'returns 0 if there are 0 pageviews' do
      metrics = build_metrics(pviews: 0)
      expect(subject.new(metrics).previous_period).to eq 0
    end

    it 'returns 0 if there are 0 unique pageviews' do
      metrics = build_metrics(upviews: 0)
      expect(subject.new(metrics).previous_period).to eq 0
    end

    it 'returns nil if there are nil pageviews' do
      metrics = build_metrics(pviews: nil)
      expect(subject.new(metrics).previous_period).to eq nil
    end

    it 'returns nil if there are nil unique pageviews' do
      metrics = build_metrics(upviews: nil)
      expect(subject.new(metrics).previous_period).to eq nil
    end

    it 'returns pageviews per visit if there are pageviews and unique pageviews' do
      metrics = build_metrics(pviews: 100, upviews: 10)
      expect(subject.new(metrics).previous_period).to eq 10
    end
  end

  def build_metrics(pviews: 10, upviews: 10)
    {
      'pviews' => {
        value: pviews
      },
      'upviews' => {
        value: upviews
      }
    }
  end
end
