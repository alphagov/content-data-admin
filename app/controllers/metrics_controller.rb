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

    raw_accessibility_issues = FetchSiteImproveAccessibilityIssues.new(url: "https://www.gov.uk/#{params[:base_path]}").call
    @accessibility_issues = AccessibilityIssuesPresenter.new(raw_accessibility_issues)
  end

  rescue_from GdsApi::HTTPNotFound do
    render "errors/404", status: :not_found
  end
end
