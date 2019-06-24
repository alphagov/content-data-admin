class FetchDocumentChildren
  include Concerns::ContentDataApiClient

  def self.call(args)
    new(args).call
  end

  def initialize(document_id:, date_range:, sort:)
    @document_id = document_id
    @from = date_range.from
    @to = date_range.to
    @sort = sort.to_s
  end

  def call
    api.document_children(document_id: @document_id, from: @from, to: @to, sort: @sort)
  end
end
