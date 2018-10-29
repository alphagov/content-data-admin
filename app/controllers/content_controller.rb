class ContentController < ApplicationController
  def index
    get_content
    organisations = FetchOrganisations.call
    @organisations = organisations[:organisations]
    @document_types = FetchDocumentTypes.call[:document_types]
  end

private

  def get_content
    response = FindContent.call(content_params)
    @content = ContentItemsPresenter.new(
      response[:results],
      DateRange.new(content_params[:date_range])
    )
    @organisation_id = content_params[:organisation_id]
    @document_type = content_params[:document_type]
  end

  def content_params
    @content_params ||= begin
      defaults = {
        date_range: 'last-30-days'
      }

      defaults.merge(
        params.permit(
          :date_range,
          :organisation_id,
          :document_type
        ).to_h.symbolize_keys
      )
    end
  end
end
