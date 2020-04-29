require "support/content_data_api"
require "support/response_helpers"

module RequestStubs
  include GdsApi::TestHelpers::ContentDataApi
  include GdsApi::TestHelpers::ResponseHelpers

  def stub_metrics_page(base_path:, time_period:, publishing_app: "whitehall", content_item_missing: false, current_data_missing: false, comparison_data_missing: false, edition_metrics_missing: false, related_content: 0, parent_document_id: nil)
    dates = build(:date_range, time_period)
    prev_dates = dates.previous

    current_period_data = single_page_response(
      base_path, dates.from, dates.to
    )
    previous_period_data = older_single_page_response(
      base_path, prev_dates.from, prev_dates.to
    )

    current_period_data[:metadata][:parent_document_id] = parent_document_id
    current_period_data[:number_of_related_content] = related_content

    current_period_data[:metadata][:publishing_app] = publishing_app
    previous_period_data[:metadata][:publishing_app] = publishing_app

    if current_data_missing
      set_time_series_metrics_to_missing(current_period_data)
      set_edition_metrics_to_missing(current_period_data)
    end

    if comparison_data_missing
      set_time_series_metrics_to_missing(previous_period_data)
      set_edition_metrics_to_missing(current_period_data)
    end

    if edition_metrics_missing
      set_edition_metrics_to_missing(current_period_data)
    end

    if content_item_missing
      content_data_api_does_not_have_base_path(
        base_path: base_path, from: dates.from, to: dates.to,
      )
    else
      content_data_api_has_single_page(
        base_path: base_path,
        from: dates.from,
        to: dates.to,
        payload: current_period_data,
      )
      content_data_api_has_single_page(
        base_path: base_path,
        from: prev_dates.from,
        to: prev_dates.to,
        payload: previous_period_data,
      )
    end
  end

  def stub_document_children_page(document_id:, time_period: "past-30-days", sort: "sibling_order:asc", response: nil)
    response = document_children_response if response.nil?

    content_data_api_has_document_children(
      document_id: document_id,
      payload: response,
      time_period: time_period,
      sort: sort,
    )
  end

  def stub_content_page(time_period:, organisation_id: nil, document_type: nil, search_terms: nil, sort: "upviews:desc", items: nil)
    content_data_api_has_orgs
    content_data_api_has_document_types

    items = content_response[:results] if items.nil?

    content_data_api_has_content_items(
      date_range: time_period,
      organisation_id: organisation_id,
      document_type: document_type,
      search_term: search_terms,
      sort: sort,
      items: items,
    )
  end

  def stub_content_page_csv_download(time_period:, organisation_id: nil, document_type: nil, search_terms: nil, sort: "upviews:desc", items:)
    content_data_api_has_content_items(
      date_range: time_period,
      organisation_id: organisation_id,
      document_type: document_type,
      search_term: search_terms,
      items: items,
      sort: sort,
      page_size: 5000,
    )
  end

  def set_time_series_metrics_to_missing(response)
    response[:time_series_metrics].each do |metric|
      metric[:total] = nil
      metric[:time_series] = []
    end
  end

  def set_edition_metrics_to_missing(response)
    response[:edition_metrics].each do |metric|
      metric[:value] = nil
    end
  end
end
