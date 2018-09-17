class MetricsController < ApplicationController
  def show
    service = MetricsService.new
    date_range = DateRange.new(params[:date_range])

    service_params = {
      base_path: params[:base_path],
      date_range: date_range,
    }

    metrics = service.fetch_aggregated_data(service_params)
    time_series = service.fetch_time_series(service_params)
    @summary = SingleContentItemPresenter.new(metrics, time_series, date_range)
  end

  rescue_from GdsApi::HTTPNotFound do
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
