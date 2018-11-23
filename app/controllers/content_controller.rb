class ContentController < ApplicationController
  include PaginationHelper
  include Concerns::ExportableToCSV

  layout 'application'
  before_action :set_constants

  def set_constants
    @fullwidth = true
  end

  def index
    document_types = FetchDocumentTypes.call[:document_types]
    organisations = FetchOrganisations.call[:organisations]

    respond_to do |format|
      format.html do
        search_results = FindContent.call(search_params)

        @presenter = ContentItemsPresenter.new(
          search_results, search_params, document_types, organisations,
        )
      end
      format.csv do
        presenter = ContentItemsCSVPresenter.new(
          FindContent.enum(search_params),
          DateRange.new(search_params[:date_range]),
          document_types,
          organisations
        )

        export_to_csv(enum: presenter.csv_rows)
      end
    end
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
          :page,
          :search_term,
        ).to_h.symbolize_keys
      )
    end
  end
end
