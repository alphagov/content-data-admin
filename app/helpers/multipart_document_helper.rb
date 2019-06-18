module MultipartDocumentHelper
  MULTIPART_DOCUMENTS = %w(html_publication guide manual).freeze
  DOCUMENT_PART_NAMES = { html_publication: "publications", guide: "chapters", manual: "sections" }.freeze

  def multipart?(document_type)
    MULTIPART_DOCUMENTS.include?(document_type.parameterize.underscore)
  end

  def part_name(document_type)
    document_type = document_type.parameterize.underscore
    if multipart?(document_type)
      DOCUMENT_PART_NAMES[document_type.to_sym]
    end
  end
end
