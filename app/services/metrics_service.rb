require 'gds_api/content_data_api'

class MetricsService
  include MetricsCommon

  def fetch_aggregated_data(base_path:, date_range:)
    api.aggregated_metrics(base_path: base_path, from: date_range.from, to: date_range.to, metrics: default_metrics)
  end

  def fetch_time_series(base_path:, date_range:)
    api.time_series(base_path: base_path, from: date_range.from, to: date_range.to, metrics: default_metrics)
  end
end
