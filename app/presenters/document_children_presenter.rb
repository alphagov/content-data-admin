class DocumentChildrenPresenter
  attr_reader :title, :content_items

  def initialize(documents)
    @title = 'Comparision'

    @content_items = documents.map { |d| ContentRowPresenter.new(d) }
  end
end
