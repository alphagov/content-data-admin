class ContentController < ApplicationController
  def index
    @content = get_content
  end

private

  def get_content
    response = FindContent.call(params)
    @content = ContentItemsPresenter.new(response.deep_symbolize_keys[:results])
  end

  def date_range
    DateRange.new(params[:date_range])
  end
end
