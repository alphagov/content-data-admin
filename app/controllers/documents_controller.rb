# frozen_string_literal: true

class DocumentsController < ApplicationController
  layout 'application'
  before_action :set_constants

  def set_constants
    @fullwidth = true
  end

  def children
    @hkey = params[:hkey]
  end
end
