module DateRangeHelpers
  include ActiveSupport::Testing::TimeHelpers

  def get_date_ranges(relative_date:)
    travel_to(relative_date) do
      {
        last_30_days: {
          current: { to: relative_date, from: 30.days.ago },
          previous: { to: 30.days.ago, from: 60.days.ago }
        },
        last_month: {
          current: { to: 1.month.ago.end_of_month, from: 1.month.ago.beginning_of_month },
          previous: { to: 2.months.ago.end_of_month, from: 2.months.ago.beginning_of_month }
        },
        last_3_months: {
          current: { to: relative_date, from: 3.months.ago },
          previous: { to: 3.months.ago, from: 6.months.ago }
        },
        last_6_months: {
          current: { to: relative_date, from: 6.months.ago },
          previous: { to: 6.months.ago, from: 1.year.ago }
        },
        last_year: {
          current: { to: relative_date, from: 1.year.ago },
          previous: { to: 1.year.ago, from: 2.years.ago }
        },
        last_2_years: {
          current: { to: relative_date, from: 2.years.ago },
          previous: { to: 2.years.ago, from: 4.years.ago }
        }
      }
    end
  end
end
