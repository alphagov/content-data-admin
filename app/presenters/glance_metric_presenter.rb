class GlanceMetricPresenter
  def initialize(metric_name, metric_value, time_period)
    @metric_name = metric_name
    @metric_value = metric_value
    @time_period = time_period

    # Context metrics are variables that can be used in the locales.
    # Dummy values are being used until they are available from API
    @context_metrics = {
      percent_org_views: 2.74,
      total_responses: 505,
      percent_users_searched: 0.18
    }
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

  def context
    I18n.t("metrics.#{@metric_name}.context", @context_metrics)
  end

  def period
    I18n.t("metrics.show.time_periods.#{@time_period}.reference")
  end
end
