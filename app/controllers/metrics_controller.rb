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

    setup_siteimprove
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
    return unless current_user.view_email_subs?

    @show_email_subs_section = true
    @email_subscriptions = {
      subscriber_list_count: 12,
      all_notify_count: 26,
    }
  end

  def setup_siteimprove
    return unless current_user.view_siteimprove?

    begin
      @summary_info = Siteimprove::FetchSummary.call(url: "https://www.gov.uk/#{base_path}")
      raw_policy_issues = Siteimprove::FetchPolicyIssues.call(url: "https://www.gov.uk/#{base_path}")
      @policy_issues = Siteimprove::PolicyIssuesPresenter.new(raw_policy_issues, @summary_info)
      raw_quality_assurance_issues = Siteimprove::FetchQualityAssuranceIssues.call(url: "https://www.gov.uk/#{base_path}")
      @quality_assurance_issues = Siteimprove::QualityAssuranceIssuesPresenter.new(raw_quality_assurance_issues, @summary_info)
      @has_accessibility_info = @policy_issues.any? || @quality_assurance_issues.any?
    rescue Siteimprove::BaseError
      @has_accessibility_info = false
    end
  end
end
