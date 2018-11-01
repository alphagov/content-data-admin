module PaginationHelper
  include Kaminari::Helpers::HelperMethods
  attr_accessor :content

  def navigation_links
    result = {}
    if @presenter.prev_link?
      result = result.merge(
        previous_page:  {
          url: path_to_prev_page(@presenter.content_items),
          title: 'Previous',
          label: "#{@presenter.page - 1} of #{@presenter.total_pages}"
        }
      )
    end

    if @presenter.next_link?
      result = result.merge(
        next_page: {
          url: path_to_next_page(@presenter.content_items),
          title: 'Next',
          label: "#{@presenter.page + 1} of #{@presenter.total_pages}"
        }
      )
    end
    result
  end
end
