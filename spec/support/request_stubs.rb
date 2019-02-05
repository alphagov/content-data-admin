require 'support/content_data_api'

module RequestStubs
  include GdsApi::TestHelpers::ContentDataApi

  def stub_metrics_page(base_path:, time_period:, publishing_app: 'whitehall')
    dates = build(:date_range, time_period)
    prev_dates = dates.previous

    current_period_data = default_single_page_payload(
      base_path, dates.from, dates.to
    )
    previous_period_data = default_previous_single_page_payload(
      base_path, prev_dates.from, prev_dates.to
    )

    current_period_data[:metadata][:publishing_app] = publishing_app
    previous_period_data[:metadata][:publishing_app] = publishing_app

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
