class MetricsController < ApplicationController
  def show
    time_period = params[:date_range] || "past-30-days"

    curr_period = DateRange.new(time_period)
    prev_period = curr_period.previous

    curr_period_data = FetchSinglePage.call(base_path:, date_range: curr_period)
    prev_period_data = FetchSinglePage.call(base_path:, date_range: prev_period)

    @performance_data = SingleContentItemPresenter.new(
      curr_period_data,
      prev_period_data,
      curr_period,
    )

    setup_email_subscriptions
  end

  rescue_from GdsApi::HTTPNotFound do
    render "errors/404", status: :not_found
  end

private

  def base_path
    params[:base_path]
  end

  def setup_email_subscriptions
    @email_subscriptions = EmailApi::PageSubscriptionsClient.new.fetch(path: "/#{base_path}")
  end
end
