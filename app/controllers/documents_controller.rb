# frozen_string_literal: true

class DocumentsController < ApplicationController
  layout 'application'
  before_action :set_constants

  def set_constants
    @fullwidth = true
  end

  def children
    @hkey = params[:hkey]
    time_period = params[:date_range] || 'past-30-days'
    document_id = params[:document_id]

    @date_range = DateRange.new(time_period)

    response = FetchDocumentChildren.call(document_id: document_id, date_range: @date_range)
    @presenter = DocumentChildrenPresenter.new(response[:documents])
  end
end
