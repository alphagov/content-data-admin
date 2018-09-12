class MetricsController < ApplicationController
  def show
    service = MetricsService.new

    service_params = {
      base_path: params[:base_path],
      from: params[:from],
      to: params[:to]
    }

    @summary = SingleContentItemPresenter
      .parse_metrics(
        metrics: service.fetch_aggregated_data(service_params),
        from: params[:from],
        to: params[:to]
      )
      .parse_time_series(service.fetch_time_series(service_params))
  end

  rescue_from GdsApi::HTTPNotFound do
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
