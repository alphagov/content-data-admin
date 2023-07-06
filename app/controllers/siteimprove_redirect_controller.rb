class SiteimproveRedirectController < ApplicationController
  before_action :fetch_summary

  def quality_assurance
    redirect_to Siteimprove::SummaryPresenter.new(@summary_info).quality_assurance_link, allow_other_host: true
  end

  def accessibility
    redirect_to Siteimprove::SummaryPresenter.new(@summary_info).accessibility_link, allow_other_host: true
  end

  def seo
    redirect_to Siteimprove::SummaryPresenter.new(@summary_info).seo_link, allow_other_host: true
  end

  def policy
    redirect_to Siteimprove::SummaryPresenter.new(@summary_info).policy_link, allow_other_host: true
  end

private

  def fetch_summary
    @summary_info = Siteimprove::FetchSummary.new(url: "https://www.gov.uk/#{params[:base_path]}").call
  rescue Siteimprove::PageNotFound
    render "errors/404", status: :not_found
  end
end
