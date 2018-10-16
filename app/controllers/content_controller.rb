class ContentController < ApplicationController
  def index
    @content = get_content
    organisations = FetchOrganisations.call
    @organisations = organisations[:organisations]
  end

private

  def get_content
    response = FindContent.call(params)
    @content = ContentItemsPresenter.new(response[:results], date_range)
  end

  def date_range
    time_period = params[:date_range].presence || 'last-30-days'
    DateRange.new(time_period)
  end
end
