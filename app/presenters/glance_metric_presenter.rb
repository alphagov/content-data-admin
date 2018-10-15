class GlanceMetricPresenter
  def initialize(metric_name, metric_value, time_period, _secondary_metric_value = nil, context: {})
    @metric_name = metric_name
    @metric_value = metric_value
    @time_period = time_period
  end

  def name
    short_title = I18n.t("metrics.#{@metric_name}.short_title")
    title = I18n.t("metrics.#{@metric_name}.title")
    short_title.empty? ? title : short_title
  end

  def value
    @metric_value
  end

  def trend_percentage
    0
  end

  def period
    I18n.t("metrics.show.time_periods.#{@time_period}.reference")
  end
end
