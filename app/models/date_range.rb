class DateRange
  attr_reader :time_period, :to, :from

  def initialize(time_period, relative_date = nil)
    relative_date = relative_date || Time.zone.yesterday

    @time_period = time_period
    @to = date_to_range(relative_date, time_period)[:to]
    @from = date_to_range(relative_date, time_period)[:from]
  end

  def previous
    relative_date = @from
    relative_date -= 1.day unless @time_period == "last-month"
    DateRange.new(time_period, relative_date)
  end

private

  def date_to_range(relative_date, time_period)
    case time_period
    when "last-month"
      {
        from: relative_date.last_month.beginning_of_month,
        to: relative_date.last_month.end_of_month,
      }
    when "past-3-months"
      {
        from: (relative_date - 3.months) + 1.day,
        to: relative_date,
      }
    when "past-6-months"
      {
        from: (relative_date - 6.months) + 1.day,
        to: relative_date,
      }
    when "past-year"
      {
        from: (relative_date - 1.year) + 1.day,
        to: relative_date,
      }
    when "past-2-years"
      {
        from: (relative_date - 2.years) + 1.day,
        to: relative_date,
      }
    else
      {
        from: relative_date - 29.days,
        to: relative_date,
      }
    end
  end
end
