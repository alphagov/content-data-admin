class FindContent
  def self.call(args)
    new(*args).call
  end

  def initialize(params)
    range = DateRange.new(params[:date_range])
    @from = range.from
    @to = range.to
    @organisation = params[:organisation]
  end

  def call
    api.content(from: @from, to: @to, organisation: @organisation)
  end

private

  def api
    @api ||= GdsApi::ContentDataApi.new
  end
end
