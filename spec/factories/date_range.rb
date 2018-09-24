FactoryBot.define do
  factory :date_range, class: DateRange do
    trait :last_30_days do
      initialize_with { new('last-30-days') }
    end

    trait :last_month do
      initialize_with { new('last-month') }
    end

    trait :last_3_months do
      initialize_with { new('last-3-months') }
    end

    trait :last_6_months do
      initialize_with { new('last-6-months') }
    end

    trait :last_year do
      initialize_with { new('last-year') }
    end

    trait :last_2_years do
      initialize_with { new('last-2-years') }
    end
  end
end
