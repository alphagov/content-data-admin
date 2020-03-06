module TimeSelectHelper
  METRIC_PAGE_TIME_PERIODS = ["past-30-days", "last-month", "past-3-months", "past-6-months", "past-year", "past-2-years"].freeze
  CONTENT_PAGE_TIME_PERIODS = ["past-30-days", "last-month", "past-3-months", "past-6-months", "past-year"].freeze

  def time_select_options(time_periods)
    time_periods.map do |time_period|
      date_range = DateRange.new(time_period)
      start_date = date_range.from.to_s(:long_date)
      end_date = date_range.to.to_s(:long_date)

      {
        value: time_period,
        text: I18n.t("metrics.show.time_periods.#{time_period}.leading"),
        hint_text: "#{start_date} to #{end_date}",
      }
    end
  end

  def custom_months
    years = (2018..Time.zone.today.year).to_a.freeze
    months = Date::MONTHNAMES.compact

    years.flat_map do |year|
      months.map do |month|
        "#{month.downcase}-#{year}"
      end
    end
  end

  def custom_month_selected(time_period)
    custom_months.include?(time_period)
  end
end
