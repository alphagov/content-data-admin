class ContentItemsPresenter
  include Kaminari::Helpers::HelperMethods
  attr_reader :items, :title, :date_range, :page, :total_pages

  def initialize(response, search_parameters)
    @title = 'Content Items'
    @date_range = DateRange.new(search_parameters[:date_range])
    @total_results = response[:total_results]
    @total_pages = response[:total_pages]
    @page = response[:page] || 1
    @items = paginate(response[:results].map { |ci| ContentRowPresenter.new(ci) })
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
