require 'gds_api/base'
class MetricsService
  attr_reader :base_path, :from, :to, :metric

  def fetch(base_path:, from:, to:, metric:)
    url = request_url(base_path, from, to, metric)
    client.get_json(url)
  end

  def fetch_timeseries(base_path:, from:, to:, metric:)
    url = time_series_request_url(base_path, from, to, metric)
    data = client.get_json(url).to_hash
    format_response(data, metric, from, to)
  end

private

  def format_response(data, metric, from, to)
    human_friendly_metric = human_friendly_metric(metric)
    {
      caption: "#{human_friendly_metric} from #{from.to_date} to #{to.to_date}",
      chart_label: "#{human_friendly_metric} chart",
      table_label: "#{human_friendly_metric} table",
      chart_id: "#{metric}_#{from}-#{to}_chart",
      table_id: "#{metric}_#{from}-#{to}_table",
      keys: keys(data, metric),
      rows: [
        {
          values: values(data, metric)
        }
      ]
    }
  end

  def keys(data, metric)
    dates = data[metric].map { |hash| hash['date'] }
    dates.map { |date| date.last(5) }
  end

  def values(data, metric)
    data[metric].map { |hash| hash['value'] }
  end

  def human_friendly_metric(metric)
    metric.tr('_', ' ').capitalize
  end

  def request_url(base_path, from, to, metric)
    "#{content_data_api_endpoint}/metrics/#{metric}/#{base_path}?from=#{from}&to=#{to}"
  end

  def time_series_request_url(base_path, from, to, metric)
    "#{content_data_api_endpoint}/metrics/#{metric}/#{base_path}/time-series?from=#{from}&to=#{to}"
  end

  def content_data_api_endpoint
    "#{Plek.current.find('content-performance-manager')}/api/v1"
  end

  def client
    @client ||= GdsApi::Base.new(content_data_api_endpoint,
                                 disable_cache: true,
                                 bearer_token: ENV['CONTENT_PERFORMANCE_MANAGER_BEARER_TOKEN'] || 'example').client
  end
end
