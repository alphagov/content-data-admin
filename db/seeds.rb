def seed
  if User.where(name: "Test user").present?
    puts "Skipping because user already exists"
    return
  end
  create_test_user
end

def create_test_user
  gds_organisation_id = "af07d5a5-df63-4ddc-9383-6a666845ebe9"

  User.create!(
    name: "Test user",
    permissions: %w[signin gds_editor],
    organisation_content_id: gds_organisation_id,
  )
end

seed
