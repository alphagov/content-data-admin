class ChartPresenter
  include MetricsFormatterHelper
  attr_reader :time_series, :metric, :from, :to

  def initialize(json:, metric:, date_range:)
    @metric = metric
    @time_series = json
    @from = date_range.from
    @to = date_range.to
  end

  def has_values?
    !time_series.empty?
  end

  def no_data_message
    "No #{human_friendly_metric} data for the selected time period"
  end

  def chart_data
    {
      caption: "#{human_friendly_metric} from #{from.to_date} to #{to.to_date}",
      chart_label: human_friendly_metric.to_s,
      chart_id: "#{metric}_chart",
      table_id: "#{metric}_table",
      table_direction: "vertical",
      keys: keys,
      rows: [
        {
          label: "#{human_friendly_metric} ",
          values: values
        }
      ]
    }
  end

  def keys
    padded_time_series.map { |h| h[:date] }
  end

  def values
    padded_time_series.map { |h| h[:value] }
  end

private

  def padded_time_series
    @padded_time_series ||= (from.to_date..to.to_date).map do |date|
      date_str = date.strftime("%m-%d")
      { date: date_str, value: time_series_hash[date_str] || nil }
    end
  end

  def time_series_hash
    return [] unless time_series
    @time_series_hash ||= create_time_series_hash
  end

  def create_time_series_hash
    pairs = time_series.map do |point|
      [point[:date].to_date.strftime("%m-%d"), format_metric_value(metric, point[:value])]
    end
    pairs.to_h
  end

  def human_friendly_metric
    I18n.t "metrics.#{metric}.title"
  end
end
