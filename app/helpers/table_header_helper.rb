module TableHeaderHelper
  HEADER_NAMES = %w(title document_type upviews satisfaction searches).freeze
  HEADERS_WITH_SORT_ENABLED = %w(document_type upviews satisfaction searches).freeze

  COMPARISON_HEADER_NAMES = %w(sibling_order title document_type upviews satisfaction searches).freeze
  COMPARISON_HEADERS_WITH_SORT_ENABLED = %w(sibling_order upviews satisfaction searches).freeze

  REVERSE_DEFAULT_DIRECTION = %w(title document_type sibling_order).freeze
  HEADERS_WITH_HELP_ICON = %w(upviews satisfaction searches).freeze


  def include_help_icon?(header_name)
    HEADERS_WITH_HELP_ICON.include?(header_name)
  end

  def aria_sort(direction)
    direction.present? ? direction + "ending" : "none"
  end

  def sort_param(header_name, direction)
    if direction.present?
      sort = Sort.new(header_name, direction)
      sort.reverse!
    else
      sort = Sort.new(header_name, "desc")
      sort.reverse! if REVERSE_DEFAULT_DIRECTION.include?(header_name)
    end
    sort.to_s
  end
end
