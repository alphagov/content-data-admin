class DateRange
  attr_reader :time_period, :to, :from

  def initialize(time_period, relative_date = nil)
    relative_date = relative_date || Time.zone.yesterday

    @time_period = time_period
    @to = date_to_range(relative_date, time_period)[:to]
    @from = date_to_range(relative_date, time_period)[:from]
  end

  def previous
    relative_date = Date.parse(@from)
    relative_date = relative_date - 1.day unless @time_period == 'last-month'
    DateRange.new(time_period, relative_date)
  end

private

  def date_to_range(relative_date, time_period)
    case time_period
    when 'last-month'
      {
        from: relative_date.last_month.beginning_of_month.to_s,
        to: relative_date.last_month.end_of_month.to_s
      }
    when 'past-3-months'
      {
        from: ((relative_date - 3.months) + 1.day).to_s,
        to: relative_date.to_s
      }
    when 'past-6-months'
      {
        from: ((relative_date - 6.months) + 1.day).to_s,
        to: relative_date.to_s
      }
    when 'past-year'
      {
        from: ((relative_date - 1.year) + 1.day).to_s,
        to: relative_date.to_s
      }
    when 'past-2-years'
      {
        from: ((relative_date - 2.years) + 1.day).to_s,
        to: relative_date.to_s
      }
    else
      {
        from: (relative_date - 29.days).to_s,
        to: relative_date.to_s
      }
    end
  end
end
