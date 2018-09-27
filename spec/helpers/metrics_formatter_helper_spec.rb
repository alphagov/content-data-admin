RSpec.describe MetricsFormatterHelper do
  context 'metric needs to be rendered as a percentage' do
    it 'displays value as a percentage' do
      value = format_metric_value('satisfaction_score', 90.000)
      expect(value).to eq '90%'
    end
  end

  context 'metric does not need to be rendered as a percentage' do
    it 'displays value as an integer' do
      value = format_metric_value('pageviews', 90)
      expect(value).to eq 90
    end
  end

  context 'if figure for percentage metric is not supplied' do
    it 'does not raise an error' do
      expect { format_metric_value('satisfaction_score', nil) }.to_not raise_error
    end
  end
end
