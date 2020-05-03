class DateRange
  attr_reader :to, :from
  attr_accessor :time_period

  def initialize(time_period, relative_date = nil)
    relative_date ||= Time.zone.yesterday
    @time_period = time_period
    @to = date_to_range(relative_date, time_period)[:to]
    @from = date_to_range(relative_date, time_period)[:from]
  end

  def previous
    relative_date = @from
    relative_date -= 1.day unless @time_period == "last-month"
    if specific_month_requested
      DateRange.new(previous_specific_month)
    else
      DateRange.new(time_period, relative_date)
    end
  end

private

  YEARS = (2018..Time.zone.today.year).to_a.freeze
  MONTHS = Date::MONTHNAMES.compact

  def date_to_range(relative_date, time_period)
    return specified_month if specific_month_requested

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
      @time_period = "past-30-days"
      {
        from: relative_date - 29.days,
        to: relative_date,
      }
    end
  end

  def specific_month_requested
    @specific_month_requested ||= months_and_years.include?(@time_period)
  end

  def previous_specific_month
    months_and_years[months_and_years.index(time_period) - 1]
  end

  def months_and_years
    @months_and_years ||= YEARS.flat_map do |year|
      MONTHS.map do |month|
        "#{month.downcase}-#{year}"
      end
    end
  end

  def specified_month
    month = Date.parse(time_period)
    {
      from: month.beginning_of_month,
      to: month.end_of_month,
    }
  end
end
