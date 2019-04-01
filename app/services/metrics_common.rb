require 'gds_api/content_data_api'

module MetricsCommon
private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end

  def default_metrics
    @default_metrics ||= %w[pviews upviews searches feedex pdf_count words satisfaction useful_yes useful_no].freeze
  end
end
