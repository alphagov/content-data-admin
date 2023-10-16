class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  before_action :authenticate_user!
  before_action :downcase_date_range

private

  def downcase_date_range
    foo = "bar"
    params[:date_range].downcase! if params[:date_range]
  end
end
