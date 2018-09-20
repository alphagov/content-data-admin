require 'gds_api/content_data_api'

module MetricsCommon
private

  def api
    @api ||= GdsApi::ContentDataApi.new.tap do |client|
      client.options[:timeout] = 15
    end
  end

  def default_metrics
    @default_metrics ||= %w[pageviews unique_pageviews number_of_internal_searches feedex_comments].freeze
  end
end
