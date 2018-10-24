class ContentController < ApplicationController
  def index
    get_content
    organisations = FetchOrganisations.call
    @organisations = organisations[:organisations]
    @document_types = FetchDocumentTypes.call[:document_types]
  end

private

  def get_content
    response = FindContent.call(params)
    @content = ContentItemsPresenter.new(response[:results], date_range)
    @organisation_id = params[:organisation_id]
    @document_type = params[:document_type]
  end

  def date_range
    time_period = params[:date_range].presence || 'last-30-days'
    DateRange.new(time_period)
  end
end
