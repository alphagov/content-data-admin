def seed
  unless Rails.env.development? || ENV["RUN_SEEDS_IN_PRODUCTION"]
    puts "Skipping because not in development"
    return
  end

  if User.where(name: "Test user").present?
    puts "Skipping because user already exists"
    return
  end

  gds_organisation_id = "af07d5a5-df63-4ddc-9383-6a666845ebe9"

  user = User.create!(
    name: "Test user",
    organisation_content_id: gds_organisation_id,
    organisation_slug: "government-digital-service",
  )
end

seed
