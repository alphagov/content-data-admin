class FetchSinglePage
  include Concerns::ContentDataApiClient

  def self.call(args)
    new(args).call
  end

  def initialize(base_path:, date_range:)
    @base_path = base_path
    @from = date_range.from
    @to = date_range.to
  end

  def call
    api.single_page(base_path: @base_path, from: @from, to: @to)
  end
end
