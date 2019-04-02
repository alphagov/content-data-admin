class Calculator::PageviewsPerVisit
  attr_reader :pageviews, :unique_pageviews

  def self.calculate(*args)
    new(*args).calculate
  end

  def initialize(pageviews:, unique_pageviews:)
    @pageviews = pageviews
    @unique_pageviews = unique_pageviews
  end

  def calculate
    return nil if pageviews.blank? || unique_pageviews.blank?

    pageviews_float = pageviews.to_f
    unique_pageviews_float = unique_pageviews.to_f

    return 0 if pageviews_float.zero? || unique_pageviews_float.zero?

    (pageviews_float / unique_pageviews_float).round(2)
  end
end
