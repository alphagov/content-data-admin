class ContentItemsPresenter
  attr_reader :items, :title, :date_range
  def initialize(content_items, date_range)
    @items = content_items.map { |ci| ContentRowPresenter.new(ci) }
    @title = 'Content Items'
    @date_range = date_range
  end
end
