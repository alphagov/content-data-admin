class FetchSinglePage
  include MetricsCommon
  def self.call(args)
    new(args).call
  end

  def initialize(base_path, to, from)
    @base_path = base_path
    @from = from
    @to = to
  end

  def call
    api.single_page(base_path: @base_path, from: @from, to: @to)
  end
end
