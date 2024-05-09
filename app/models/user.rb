class User < ApplicationRecord
  include GDS::SSO::User

  def view_siteimprove?
    permissions.include?("view_siteimprove")
  end
end
