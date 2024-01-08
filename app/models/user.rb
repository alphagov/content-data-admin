class User < ApplicationRecord
  include GDS::SSO::User

  def view_siteimprove?
    permissions.include?("view_siteimprove")
  end

  def view_email_subs?
    permissions.include?("view_email_subs")
  end
end
