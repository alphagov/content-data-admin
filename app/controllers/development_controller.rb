# frozen_string_literal: true

class DevelopmentController < ApplicationController
  layout 'application'
  before_action :set_constants

  def set_constants
    @fullwidth = true
  end
end
