require 'support/content_data_api'
require 'support/response_helpers'

module RequestStubs
  include GdsApi::TestHelpers::ContentDataApi
  include GdsApi::TestHelpers::ResponseHelpers

  def stub_metrics_page(base_path:, time_period:, publishing_app: 'whitehall', content_item_missing: false, current_data_missing: false, comparision_data_missing: false)
    dates = build(:date_range, time_period)
    prev_dates = dates.previous

    current_period_data = single_page_response(
      base_path, dates.from, dates.to
    )
    previous_period_data = older_single_page_response(
      base_path, prev_dates.from, prev_dates.to
    )

    current_period_data[:metadata][:publishing_app] = publishing_app
    previous_period_data[:metadata][:publishing_app] = publishing_app

    if current_data_missing
      set_content_item_metrics_to_missing(current_period_data)
    end

    if comparision_data_missing
      set_content_item_metrics_to_missing(previous_period_data)
    end

    if content_item_missing
      content_data_api_does_not_have_base_path(
        base_path: base_path, from: dates.from, to: dates.to
      )
    else
      content_data_api_has_single_page(
        base_path: base_path,
        from: dates.from,
        to: dates.to,
        payload: current_period_data
      )
      content_data_api_has_single_page(
        base_path: base_path,
        from: prev_dates.from,
        to: prev_dates.to,
        payload: previous_period_data
      )
    end
  end

  def stub_content_page(time_period:, organisation_id: nil, document_type: nil, search_terms: nil, items:)
    content_data_api_has_orgs
    content_data_api_has_document_types

    content_data_api_has_content_items(
      date_range: time_period,
      organisation_id: organisation_id,
      document_type: document_type,
      search_term: search_terms,
      items: items
    )
  end

  def stub_content_page_csv_download(time_period:, organisation_id: nil, document_type: nil, search_terms: nil, items:)
    content_data_api_has_content_items(
      date_range: time_period,
      organisation_id: organisation_id,
      document_type: document_type,
      search_term: search_terms,
      items: items,
      page_size: 5000
    )
  end

  def set_content_item_metrics_to_missing(response)
    response[:time_series_metrics].each do |metric|
      metric[:total] = nil
      metric[:time_series] = []
    end

    response[:edition_metrics].each do |metric|
      metric[:value] = nil
    end
  end
end
