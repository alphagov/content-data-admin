class MetricsController < ApplicationController
  DEFAULT_METRICS = %w[pageviews unique_pageviews number_of_internal_searches].freeze

  def show
    service = MetricsService.new

    service_params = {
      base_path: params[:base_path],
      from: params[:from],
      to: params[:to],
      metrics: DEFAULT_METRICS
    }

    @summary = SingleContentItemPresenter
      .parse_metrics(service.fetch(service_params))
      .parse_time_series(service.fetch_time_series(service_params))
  end

  rescue_from GdsApi::HTTPNotFound do
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
