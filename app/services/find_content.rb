class FindContent
  include MetricsCommon

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    range = DateRange.new(params[:date_range])
    @from = range.from
    @to = range.to
    @organisation = params[:organisation_id]
    @document_type = params[:document_type]
  end

  def call
    api.content(from: @from, to: @to, organisation_id: @organisation, document_type: @document_type)
  end
end
