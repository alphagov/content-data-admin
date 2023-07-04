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

    raw_confirmed_accessibility_issues = FetchSiteImproveAccessibilityIssues.new(url: "https://www.gov.uk/#{params[:base_path]}").call
    @confirmed_accessibility_issues = AccessibilityIssuesPresenter.new(raw_confirmed_accessibility_issues)
    raw_potential_accessibility_issues = FetchSiteImproveAccessibilityIssues.new(url: "https://www.gov.uk/#{params[:base_path]}", level: "potential").call
    @potential_accessibility_issues = AccessibilityIssuesPresenter.new(raw_potential_accessibility_issues)
    raw_policy_issues = FetchSiteImprovePolicyIssues.new(url: "https://www.gov.uk/#{params[:base_path]}").call
    @policy_issues = PolicyIssuesPresenter.new(raw_policy_issues)
  end

  rescue_from GdsApi::HTTPNotFound do
    render "errors/404", status: :not_found
  end
end
