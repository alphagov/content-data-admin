module CustomMetricsHelper
  def calculate_average_searches_per_user(searches:, unique_pageviews:)
    searches = searches.to_f
    unique_pageviews = unique_pageviews.to_f

    return 0 if searches.zero? || unique_pageviews.zero?

    search_rate = (searches / unique_pageviews) * 100
    search_rate = 100 if search_rate > 100
    search_rate.round(2)
  end
end
