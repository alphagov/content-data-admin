class ChartPresenter
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
    metric.to_s.tr('_', ' ').capitalize
  end

  def no_data_message
    "No #{human_friendly_metric} data for the selected time period"
  end

  def chart_data
    {
      caption: "#{human_friendly_metric} from #{from.to_date} to #{to.to_date}",
      chart_label: "#{human_friendly_metric} chart",
      table_label: "#{human_friendly_metric} table",
      chart_id: "#{metric}_#{from}-#{to}_chart",
      table_id: "#{metric}_#{from}-#{to}_table",
      keys: keys,
      rows: [
        {
          values: values
        }
      ]
    }
  end

  def keys
    dates = json[metric].map { |hash| hash['date'] }
    dates.map { |date| date.last(5) }
  end

  def values
    json[metric].map { |hash| hash['value'] }
  end
end
