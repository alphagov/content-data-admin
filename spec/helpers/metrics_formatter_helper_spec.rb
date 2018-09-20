RSpec.describe MetricsFormatterHelper do
  context 'metric needs to be rendered as a percentage' do
    it 'displays value as a percentage' do
      value = format_metric_value('satisfaction_score', 0.9)
      expect(value).to eq '90%'
    end
  end

  context 'metric does not need to be rendered as a percentage' do
    it 'displays value as an integer' do
      value = format_metric_value('pageviews', 90)
      expect(value).to eq 90
    end
  end
end
