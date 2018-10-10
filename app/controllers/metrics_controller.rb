class MetricsController < ApplicationController
  def show
    time_period = params[:date_range] || 'last-30-days'
    date_range = DateRange.new(time_period)

    service_params = {
      base_path: params[:base_path],
      date_range: date_range,
    }

    metrics = FetchAggregatedMetrics.call(service_params)
    time_series = FetchTimeSeries.call(service_params)
    FetchSinglePage.call(
      base_path: params[:base_path],
      from: date_range.from,
      to: date_range.to
    )
    @performance_data = SingleContentItemPresenter.new(metrics, time_series, date_range)
  end

  rescue_from GdsApi::HTTPNotFound do
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
