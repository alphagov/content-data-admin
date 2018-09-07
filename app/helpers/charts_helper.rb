module ChartsHelper
  def render_chart(series)
    render "components/chart", series.chart_data if series.has_values?
  end
end
