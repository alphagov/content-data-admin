class MetricsController < ApplicationController
  def show
    time_period = params[:date_range] || "past-30-days"
    base_path = params[:base_path]

    curr_period = DateRange.new(time_period)
    prev_period = curr_period.previous

    curr_period_data = FetchSinglePage.call(base_path:, date_range: curr_period)
    prev_period_data = FetchSinglePage.call(base_path:, date_range: prev_period)

    @performance_data = SingleContentItemPresenter.new(
      curr_period_data,
      prev_period_data,
      curr_period,
    )
  end

  rescue_from GdsApi::HTTPNotFound do
    render "errors/404", status: :not_found
  end
end
