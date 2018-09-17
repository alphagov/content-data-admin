class DateRange
  attr_reader :time_period
  def initialize(time_period)
    @time_period = time_period
  end

  def to
    date_to_range[:to]
  end

  def from
    date_to_range[:from]
  end

private

  def date_to_range
    case time_period
    when 'last-month'
      {
        from: Time.zone.today.last_month.beginning_of_month.to_s,
        to: Time.zone.today.last_month.end_of_month.to_s
      }
    when 'last-3-months'
      {
        from: (Time.zone.today - 3.months).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-6-months'
      {
        from: (Time.zone.today - 6.months).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-1-year'
      {
        from: (Time.zone.today - 1.year).to_s,
        to: Time.zone.today.to_s
      }
    when 'last-2-years'
      {
        from: (Time.zone.today - 2.years).to_s,
        to: Time.zone.today.to_s
      }
    else
      {
        from: (Time.zone.today - 30.days).to_s,
        to: Time.zone.today.to_s
      }
    end
  end
end
