FactoryBot.define do
  factory :date_range, class: DateRange do
    trait :last_30_days do
      time_period { 'last-30-days' }
    end

    trait :last_month do
      time_period { 'last-month' }
    end

    trait :last_3_months do
      time_period { 'last-3-months' }
    end

    trait :last_6_months do
      time_period { 'last-6-months' }
    end

    trait :last_year do
      time_period { 'last-year' }
    end

    trait :last_2_years do
      time_period { 'last-2-years' }
    end

    initialize_with { new(time_period) }
  end
end
