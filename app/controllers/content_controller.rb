class ContentController < ApplicationController
  def index
    @content = get_content
  end

private

  def get_content
    response = metrics_service.content_summary(date_range: date_range,
      organisation: params[:organisation])
    @content = ContentItemsPresenter.new(response.deep_symbolize_keys[:results])
  end

  def metrics_service
    @metrics_service ||= MetricsService.new
  end

  def date_range
    DateRange.new(params[:date_range])
  end
end
