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

  factory :view_siteimprove_user, parent: :user do
    permissions { %i[view_siteimprove] }
  end
end
