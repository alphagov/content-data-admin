require 'gds_api/content_data_api'

module MetricsCommon
private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end

  def default_metrics
    @default_metrics ||= %w[pageviews unique_pageviews number_of_internal_searches].freeze
  end
end
