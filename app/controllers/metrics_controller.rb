class MetricsController < ApplicationController
  def show
    service = MetricsService.new

    service_params = {
      base_path: params[:base_path],
      from: params[:from],
      to: params[:to],
      metrics: params[:metrics]
    }

    @summary = SingleContentItemPresenter
      .parse_metrics(service.fetch(service_params))
      .parse_time_series(service.fetch_time_series(service_params))
  end
end
