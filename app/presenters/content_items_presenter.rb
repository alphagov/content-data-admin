class ContentItemsPresenter
  include Kaminari::Helpers::HelperMethods
  attr_reader :items, :title, :date_range, :page, :total_pages

  def initialize(content_items, search_parameters, document_types, organisations)
    @title = 'Content Items'
    @search_parameters = search_parameters
    @document_types = document_types
    @organisations = organisations
    @date_range = DateRange.new(search_parameters[:date_range])
    @total_results = content_items[:total_results]
    @total_pages = content_items[:total_pages]
    @page = content_items[:page] || 1
    @items = paginate(content_items[:results].map { |ci| ContentRowPresenter.new(ci) })
  end

  def prev_link?
    @page > 1
  end

  def next_link?
    @page < @total_pages
  end

  def time_period
    @search_parameters[:date_range]
  end

  def document_type_options
    types = @document_types.map do |document_type|
      {
        text: document_type.try(:tr, '_', ' ').try(:capitalize),
        value: document_type,
        selected: document_type == @search_parameters[:document_type]
      }
    end
    types.push(
      text: 'All document types',
      value: '',
      selected: @search_parameters[:document_type] == ''
    )
  end

  def organisation_options
    @organisations.map do |org|
      {
        text: org[:title],
        value: org[:organisation_id],
        selected: org[:organisation_id] == @search_parameters[:organisation_id]
      }
    end
  end

private

  def paginate(items)
    Kaminari.paginate_array(items, total_count: @total_results)
      .page(@page).per(100)
  end
end
