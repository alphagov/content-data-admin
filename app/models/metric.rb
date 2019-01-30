class Metric
  def self.parse_metrics(metrics_data)
    metrics = {}
    time_series_metrics = metrics_data[:time_series_metrics]
    edition_metrics = metrics_data[:edition_metrics]

    time_series_metrics.each do |metric|
      metrics[metric[:name]] = {
        'value': metric[:total],
        'time_series': metric[:time_series]
      }
    end

    edition_metrics.each do |metric|
      metrics[metric[:name]] = {
        'value': metric[:value],
        'time_series': nil
      }
    end
    metrics
  end
end
