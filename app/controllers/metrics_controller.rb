require 'csv'
class MetricsController < ApplicationController
  include Concerns::ExportableToCSV

  def show
    time_period = params[:date_range] || 'past-30-days'
    base_path = params[:base_path]
    metric_name = params[:metric_name]

    curr_period = DateRange.new(time_period)
    curr_period_data = FetchSinglePage.call(base_path: base_path, date_range: curr_period)

    metric_timeseries = curr_period_data[:time_series_metrics].select { |metric| metric[:name] == metric_name }.first[:time_series]

    presenter = MetricsCSVPresenter.new(metric_timeseries, base_path, metric_name)
    export_to_csv(enum: presenter.csv_rows, filename: presenter.filename)
  end
end
