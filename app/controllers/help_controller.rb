# frozen_string_literal: true

class HelpController < ApplicationController
  layout 'application'

  def show
    @hkey = params[:hkey]
  end
end
