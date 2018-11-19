class ChartPresenter
  include MetricsFormatterHelper
  attr_reader :time_series, :metric, :from, :to

  def initialize(json:, metric:, date_range:)
    @metric = metric
    @time_series = json
    @from = date_range.from.to_date
    @to = date_range.to.to_date
  end

  def has_values?
    !time_series.empty?
  end

  def no_data_message
    "No #{human_friendly_metric} data for the selected time period"
  end

  def chart_data
    {
      caption: "#{human_friendly_metric} from #{from} to #{to}",
      chart_label: human_friendly_metric.to_s,
      chart_id: "#{metric}_chart",
      table_id: "#{metric}_table",
      table_direction: "horizontal",
      from: google_charts_date_string(from),
      to: google_charts_date_string(to),
      keys: keys,
      rows: [
        {
          label: "#{human_friendly_metric} ",
          values: values
        }
      ]
    }
  end

  # https://developers.google.com/chart/interactive/docs/datesandtimes#dates-and-times-using-the-date-string-representation
  def google_charts_date_string(date)
    "Date(#{date.year}, #{date.month - 1}, #{date.day})"
  end

  def keys
    return [] unless time_series

    time_series.map do |point|
      point[:date].to_date
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
