module ChartsHelper
  def series_chart
    ChartPresenter.new(@timeseries)
  end
end
