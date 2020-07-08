class FetchTimeSeries
  include ContentDataApiClient

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @base_path = params[:base_path]
    date_range = params[:date_range]
    @from = date_range.from
    @to = date_range.to
  end

  def call
    api.time_series(base_path: @base_path, from: @from, to: @to)
  end
end
