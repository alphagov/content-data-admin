class GlanceMetricPresenter
  def initialize(metric_name, _metric_value, _time_period, _secondary_metric_value = nil, _context: {})
    @metric_name = metric_name
  end

  def name
    short_title = I18n.t("metrics.#{@metric_name}.short_title")
    title = I18n.t("metrics.#{@metric_name}.title")
    short_title.empty? ? title : short_title
  end
end
