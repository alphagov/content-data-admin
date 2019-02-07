RSpec.describe MetricsFormatterHelper do
  describe '#format_metric_value' do
    context 'metric needs to be rendered as a percentage' do
      it 'displays value as a percentage' do
        value = format_metric_value('satisfaction', 0.9000)
        expect(value).to eq '90%'
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
        expect { format_metric_value('satisfaction', nil) }.to_not raise_error
      end
    end
  end

  describe '#format_duration' do
    it 'formats duration for reading time of a few minutes' do
      expect(format_duration(5)).to eq('0h 5m')
    end

    it 'formats duration for reading time less than an hour' do
      expect(format_duration(50)).to eq('0h 50m')
    end

    it 'formats duration for reading time of several hours and minutes' do
      expect(format_duration(150)).to eq('2h 30m')
    end
  end
end
