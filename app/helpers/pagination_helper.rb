module PaginationHelper
  include Kaminari::Helpers::HelperMethods
  attr_accessor :content

  def navigation_links
    result = {}
    if content.prev_link?
      result = result.merge(
        previous_page:  {
          url: path_to_prev_page(content.items),
          title: 'Previous',
          label: "#{content.page - 1} of #{content.total_pages}"
        }
      )
    end

    if content.next_link?
      result = result.merge(
        next_page: {
          url: path_to_next_page(content.items),
          title: 'Next',
          label: "#{content.page + 1} of #{content.total_pages}"
        }
      )
    end
    result
  end
end
