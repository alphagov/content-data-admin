# frozen_string_literal: true

class CompareController < ApplicationController
  layout 'application'
  before_action :set_constants

  def set_constants
    @fullwidth = true
  end

  def show
    @hkey = params[:hkey]
  end
end
