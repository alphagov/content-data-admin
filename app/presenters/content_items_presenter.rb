class ContentItemsPresenter
  include Kaminari::Helpers::HelperMethods
  attr_reader :items, :title, :date_range, :page, :total_pages

  def initialize(content_items, date_range, total_results, total_pages, page)
    @title = 'Content Items'
    @date_range = date_range
    @total_results = total_results
    @total_pages = total_pages
    @page = page || 1
    @items = paginate(content_items.map { |ci| ContentRowPresenter.new(ci) })
  end

  def prev_link?
    @page > 1
  end

  def next_link?
    @page < @total_pages
  end

private

  def paginate(items)
    Kaminari.paginate_array(items, total_count: @total_results)
      .page(@page).per(100)
  end
end
