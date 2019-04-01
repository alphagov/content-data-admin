require 'gds_api/content_data_api'

module MetricsCommon
private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end
end
