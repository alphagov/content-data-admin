class MetricsController < ApplicationController
  def show
    time_period = params[:date_range] || 'last-30-days'
    date_range = DateRange.new(time_period)

    service_params = {
      base_path: params[:base_path],
      date_range: date_range,
    }

    glance_metrics_names = %w[unique_pageviews satisfaction_score number_of_internal_searches feedex_comments]

    aggregated_metrics = FetchAggregatedMetrics.call(service_params)
    time_series = FetchTimeSeries.call(service_params)
    @performance_data = SingleContentItemPresenter.new(aggregated_metrics, time_series, date_range)
    @glance_metrics = Hash[
      glance_metrics_names.collect { |name| [name, GlanceMetricPresenter.new(name, aggregated_metrics[name], time_period)] }
    ]
  end

  rescue_from GdsApi::HTTPNotFound do
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
