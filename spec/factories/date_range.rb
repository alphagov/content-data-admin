FactoryBot.define do
  factory :date_range, class: DateRange do
    trait :past_30_days do
      time_period { 'past-30-days' }
    end

    trait :last_month do
      time_period { 'last-month' }
    end

    trait :past_3_months do
      time_period { 'past-3-months' }
    end

    trait :past_6_months do
      time_period { 'past-6-months' }
    end

    trait :past_year do
      time_period { 'past-year' }
    end

    trait :past_2_years do
      time_period { 'past-2-years' }
    end

    initialize_with { new(time_period) }
  end
end
