class ContentController < ApplicationController
  include PaginationHelper

  def index
    document_types = FetchDocumentTypes.call[:document_types]
    organisations = FetchOrganisations.call[:organisations]
    search_results = FindContent.call(search_params)

    @presenter = ContentItemsPresenter.new(
      search_results, search_params, document_types, organisations,
    )
  end

private

  def search_params
    @search_params ||= begin
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
