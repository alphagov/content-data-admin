RSpec.describe MetricsFormatterHelper do
  context 'metric needs to be rendered as a percentage' do
    it 'displays value as a percentage' do
      value = format_metric_value('satisfaction_score', 0.9000)
      expect(value).to eq '90.000%'
    end

    it 'displays value as a percentage whole number for headline figures' do
      value = format_metric_headline_figure('satisfaction_score', 24.13413)
      expect(value).to eq '24%'
    end
  end


  context 'metric does not need to be rendered as a percentage' do
    it 'displays value as an integer' do
      value = format_metric_value('pviews', 90)
      expect(value).to eq 90
    end
  end

  context 'if figure for percentage metric is not supplied' do
    it 'does not raise an error' do
      expect { format_metric_value('satisfaction_score', nil) }.to_not raise_error
    end
  end
end
