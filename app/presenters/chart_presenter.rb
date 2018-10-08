class ChartPresenter
  include MetricsFormatterHelper
  attr_reader :json, :metric, :from, :to

  def initialize(json:, metric:, from:, to:)
    @metric = metric
    @json = json.to_h.with_indifferent_access
    @from = from
    @to = to
  end

  def has_values?
    !json.values.flatten.empty?
  end

  def human_friendly_metric
    if metric == :upviews
      'Unique pageviews'
    else
      metric.to_s.tr('_', ' ').capitalize
    end
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
    return [] unless json[metric]

    dates = json[metric].map { |hash| hash['date'] }
    dates.map { |date| date.last(5) }
  end

  def values
    return [] unless json[metric]

    json[metric].map { |hash| format_metric_value(metric, hash['value']) }
  end
end
