class GlanceMetricPresenter
  def initialize(metric_name, metric_value, time_period, secondary_metric_value = nil, context: {})
    @metric_name = metric_name
    @metric_value = metric_value
    @time_period = time_period
    @secondary_metric_value = secondary_metric_value

    # Context metrics are variables that can be used in the locales.
    # Dummy values are being used until they are available from API
    @context_metrics = context.merge(
      percent_org_views: 2.74,
      percent_users_searched: on_page_search_rate
    )
  end

  def name
    short_title = I18n.t("metrics.#{@metric_name}.short_title")
    title = I18n.t("metrics.#{@metric_name}.title")
    short_title.empty? ? title : short_title
  end

  def value
    @metric_value
  end

  def on_page_search_rate
    return unless @metric_name == :searches
    return 0 if @metric_value.to_i.zero? || @secondary_metric_value.to_i.zero?
    search_rate = (@metric_value.to_f / @secondary_metric_value.to_f) * 100
    search_rate.round(2)
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
