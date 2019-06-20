class FetchDocumentChildren
  include Concerns::ContentDataApiClient

  def self.call(args)
    new(args).call
  end

  def initialize(document_id:, date_range:)
    @document_id = document_id
    @from = date_range.from
    @to = date_range.to
  end

  def call
    api.document_children(document_id: @document_id, from: @from, to: @to)
  end
end
