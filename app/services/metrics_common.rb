module MetricsCommon
private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end

  def default_metrics
    @default_metrics ||= %w[pageviews unique_pageviews number_of_internal_searches satisfaction_score].freeze
  end
end
