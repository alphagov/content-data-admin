class ContentController < ApplicationController
  include PaginationHelper

  def index
    @document_types = FetchDocumentTypes.call[:document_types]
    organisations = FetchOrganisations.call
    response = FindContent.call(content_params)

    @organisation_id = content_params[:organisation_id]
    @document_type = content_params[:document_type]
    @organisations = organisations[:organisations]

    @content = ContentItemsPresenter.new(response, content_params, @document_types)
  end

private

  def content_params
    @content_params ||= begin
      defaults = {
        date_range: 'last-30-days',
        organisation_id: current_user.organisation_content_id,
        document_type: ''
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
