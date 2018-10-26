class ContentItemsPresenter
  attr_reader :items, :title, :date_range
  def initialize(content_items, date_range, total_results, page)
    @title = 'Content Items'
    @date_range = date_range
    @total_results = total_results
    @page = page
    @items = paginate(content_items.map { |ci| ContentRowPresenter.new(ci) })
  end

private

  def paginate(items)
    Kaminari.paginate_array(items, total_count: @total_results)
      .page(@page).per(100)
  end
end
