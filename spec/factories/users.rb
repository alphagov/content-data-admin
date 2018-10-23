FactoryBot.define do
  factory :user do
    sequence :name do |n|
      "user-#{n}"
    end

    uid { SecureRandom.uuid }
    sequence :organisation_slug do |n|
      "org-#{n}"
    end
    organisation_content_id { SecureRandom.uuid }
  end
end
