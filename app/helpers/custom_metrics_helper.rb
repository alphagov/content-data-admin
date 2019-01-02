module CustomMetricsHelper
  def calculate_pageviews_per_visit(pageviews:, unique_pageviews:)
    return nil if pageviews.blank? || unique_pageviews.blank?

    pageviews = pageviews.to_f
    unique_pageviews = unique_pageviews.to_f

    return 0 if pageviews.zero? || unique_pageviews.zero?

    (pageviews / unique_pageviews).round(2)
  end
end
