# frozen_string_literal: true

class DocumentsController < ApplicationController
  layout 'application'
  before_action :set_constants

  def set_constants
    @fullwidth = true
  end

  def children
    document_id = params[:document_id]
    time_period = params[:time_period] || 'past-30-days'
    sort = Sort.parse(params[:sort] || 'sibling_order:asc')

    @date_range = DateRange.new(time_period)

    response = FetchDocumentChildren.call(document_id: document_id, time_period: time_period, sort: sort)
    @presenter = DocumentChildrenPresenter.new(response[:documents])
  end
end
