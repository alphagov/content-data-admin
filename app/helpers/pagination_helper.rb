require "kaminari/helpers/helper_methods"

module PaginationHelper
  include Kaminari::Helpers::HelperMethods
  attr_accessor :content

  def navigation_links(presenter)
    result = {}
    if presenter.prev_link?
      result = result.merge(
        previous_page: {
          url: path_to_prev_page(presenter.content_items),
          title: "Previous",
          label: presenter.prev_label,
        },
      )
    end

    if presenter.next_link?
      result = result.merge(
        next_page: {
          url: path_to_next_page(presenter.content_items),
          title: "Next",
          label: presenter.next_label,
        },
      )
    end
    result
  end
end
