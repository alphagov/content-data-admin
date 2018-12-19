class Calculator::PageviewsPerVisit
  attr_reader :metrics
  def initialize(metrics)
    @metrics = metrics
  end

  def current_period
    return 0 if zero_pageviews? || zero_unique_pageviews?

    calculate
  end

  def previous_period
    return nil if no_pageviews_data? || no_unique_pageviews_data?
    return 0 if zero_pageviews? || zero_unique_pageviews?

    calculate
  end

private

  def zero_pageviews?
    metrics['pviews'][:value].to_f.zero?
  end

  def zero_unique_pageviews?
    metrics['upviews'][:value].to_f.zero?
  end

  def no_pageviews_data?
    metrics['pviews'][:value].blank?
  end

  def no_unique_pageviews_data?
    metrics['upviews'][:value].blank?
  end

  def calculate
    (metrics['pviews'][:value].to_f / metrics['upviews'][:value].to_f).round(2)
  end
end
