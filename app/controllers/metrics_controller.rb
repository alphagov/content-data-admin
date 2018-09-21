class MetricsController < ApplicationController
  def show
    date_range = DateRange.new(params[:date_range])

    service_params = {
      base_path: params[:base_path],
      date_range: date_range,
    }

    metrics = FetchAggregatedMetrics.call(service_params)
    time_series = FetchTimeSeries.call(service_params)
    @performance_data = SingleContentItemPresenter.new(metrics, time_series, date_range)
  end

  rescue_from GdsApi::HTTPNotFound do
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
