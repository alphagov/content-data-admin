class FetchAggregatedMetrics
  include MetricsCommon
  def self.call(args)
    new(args).call
  end

  def initialize(params)
    @base_path = params[:base_path]
    date_range = DateRange.new(params[:date_range])
    @from = date_range.from
    @to = date_range.to
  end

  def call
    api.aggregated_metrics(base_path: @base_path, from: @from, to: @to, metrics: default_metrics)
  end
end
