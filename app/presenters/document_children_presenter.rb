class DocumentChildrenPresenter
  include ActiveSupport::Inflector

  attr_reader :kicker, :content_items

  def initialize(documents)
    parent = documents.find { |d| d[:sibling_order] == nil }
    @kicker = format_page_kicker(parent[:document_type])

    @content_items = documents.map { |d| ContentRowPresenter.new(d) }
  end


private

  def format_page_kicker(document_type)
    I18n.t('documents.children.kicker', type: humanize(document_type))
  end
end
