class ContentController < ApplicationController
  include PaginationHelper
  include Concerns::ExportableToCSV

  DEFAULT_ORGANISATION_ID = 'all'.freeze

  layout 'application'
  before_action :set_constants, only: [:index]

  def set_constants
    @fullwidth = true
  end

  def index
    search_results = FindContent.call(search_params)

    @filter = FilterPresenter.new(search_params)
    @presenter = ContentItemsPresenter.new(search_results, search_params)
  end

  def export_csv
    @recipient = current_user.email

    CsvExportWorker.perform_async(search_params, @recipient, Time.zone.now)
  end

private

  def search_params
    @search_params ||= begin
      defaults = {
        date_range: 'past-30-days',
        organisation_id: DEFAULT_ORGANISATION_ID,
        document_type: '',
        sort: 'upviews:desc',
      }

      defaults.merge(
        params.permit(
          :date_range,
          :organisation_id,
          :document_type,
          :page,
          :search_term,
          :sort,
        ).to_h.symbolize_keys
      )
    end
  end
end
