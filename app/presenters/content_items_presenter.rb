class ContentItemsPresenter
  include Kaminari::Helpers::HelperMethods
  attr_reader :title, :content_items, :pagination, :filter, :search_parameters, :sort

  delegate :page, :total_pages, :prev_link?, :next_link?, :prev_label, :next_label, to: :pagination

  def initialize(search_results, search_parameters)
    @title = "Content items"
    @search_parameters = search_parameters
    @sort = Sort.parse(search_parameters[:sort])
    @pagination = PaginationPresenter.new(
      page: search_results[:page] || 1,
      total_pages: search_results[:total_pages],
      total_results: search_results[:total_results],
    )
    @content_items = pagination.paginate(search_results[:results].map { |item| ContentRowPresenter.new(item) })
  end

  def time_period
    @search_parameters[:date_range]
  end

private

  def paginate(items)
    Kaminari.paginate_array(items, total_count: @total_results)
      .page(@page).per(100)
  end
end
