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
    return [] unless time_series

    time_series.map do |point|
      point[:date].to_date.strftime("%m-%d")
    end
  end

  def values
    return [] unless time_series

    time_series.map { |point| format_metric_value(metric, point[:value]) }
  end

private

  def human_friendly_metric
    I18n.t "metrics.#{metric}.title"
  end
end
