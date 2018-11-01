class ContentController < ApplicationController
  include PaginationHelper

  def index
    @content = get_content
    @organisation_id = content_params[:organisation_id]
    @document_type = content_params[:document_type]
    organisations = FetchOrganisations.call
    @organisations = organisations[:organisations]
    @document_types = FetchDocumentTypes.call[:document_types]
  end

private

  def get_content
    response = FindContent.call(content_params)
    ContentItemsPresenter.new(
      response[:results],
        DateRange.new(content_params[:date_range]),
        response[:total_results],
        response[:total_pages],
        response[:page]
    )
  end

  def content_params
    @content_params ||= begin
      defaults = {
        date_range: 'last-30-days',
        organisation_id: current_user.organisation_content_id,
      }

      defaults.merge(
        params.permit(
          :date_range,
          :organisation_id,
          :document_type,
          :page
        ).to_h.symbolize_keys
      )
    end
  end
end
