class ContentItemsPresenter
  attr_reader :items, :title
  def initialize(content_items)
    @items = content_items.map { |ci| ContentRowPresenter.new(ci) }
    @title = 'Content Items'
  end
end
