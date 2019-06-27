class DocumentChildrenPresenter
  include ActiveSupport::Inflector

  attr_reader :kicker, :header, :title, :content_items

  def initialize(documents)
    parent = documents.find { |d| d[:sibling_order].nil? || d[:sibling_order].zero? }
    @kicker = format_page_kicker(parent[:document_type])
    @header = format_header(parent[:title], parent[:document_type])
    @title = "#{@header}: #{@kicker}"

    @content_items = documents.map { |d| ContentRowPresenter.new(d) }
  end

private

  def format_page_kicker(document_type)
    I18n.t('documents.children.kicker', type: humanize(document_type))
  end

  def format_header(title, document_type)
    if document_type == 'guide' && title.include?(':')
      title[0...title.rindex(':')]
    else
      title
    end
  end
end
