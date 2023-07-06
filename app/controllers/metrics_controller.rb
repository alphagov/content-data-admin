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

    begin
      @summary_info = Siteimprove::FetchSummary.call(url: "https://www.gov.uk/#{params[:base_path]}")

      raw_policy_issues = Siteimprove::FetchPolicyIssues.call(url: "https://www.gov.uk/#{params[:base_path]}")
      @policy_issues = Siteimprove::PolicyIssuesPresenter.new(raw_policy_issues, @summary_info)
      raw_quality_assurance_issues = Siteimprove::FetchQualityAssuranceIssues.call(url: "https://www.gov.uk/#{params[:base_path]}")
      @quality_assurance_issues = Siteimprove::QualityAssuranceIssuesPresenter.new(raw_quality_assurance_issues, @summary_info)
      @has_accessibility_info = @policy_issues.any? || @quality_assurance_issues.any?
    rescue Siteimprove::BaseError
      @has_accessibility_info = false
    end
  end

  rescue_from GdsApi::HTTPNotFound do
    render "errors/404", status: :not_found
  end
end
