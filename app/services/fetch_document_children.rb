class FetchDocumentChildren
  include ContentDataApiClient

  def self.call(**args)
    new(**args).call
  end

  def initialize(document_id:, time_period:, sort:)
    @document_id = document_id
    @time_period = time_period
    @sort = sort.to_s
  end

  def call
    api.document_children(document_id: @document_id, time_period: @time_period, sort: @sort)
  end
end
