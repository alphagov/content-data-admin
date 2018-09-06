class ChartPresenter
  attr_reader :json, :metric

  def initialize(json:, metric:)
    @metric = metric
    @json = json.to_h.with_indifferent_access
  end

  def from
    json.values.flatten.first[:date]
  end

  def to
    json.values.flatten.last[:date]
  end

  def has_values?
    !json.values.empty?
  end

  def human_friendly_metric
    metric.tr('_', ' ').capitalize
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
