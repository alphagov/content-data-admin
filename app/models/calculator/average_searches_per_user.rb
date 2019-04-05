class Calculator::AverageSearchesPerUser
  def self.calculate(*args)
    new(*args).calculate
  end

  def initialize(searches:, unique_pageviews:)
    @searches = searches
    @unique_pageviews = unique_pageviews
  end

  def calculate
    searches_float = @searches.to_f
    unique_pageviews_float = @unique_pageviews.to_f

    return 0 if searches_float.zero? || unique_pageviews_float.zero?

    search_rate = (searches_float / unique_pageviews_float) * 100
    search_rate = 100 if search_rate > 100
    search_rate.round(2)
  end
end
