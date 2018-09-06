module ChartsHelper
  def series_chart(metric)
    ChartPresenter.new(json: @timeseries, metric: metric)
  end
end
