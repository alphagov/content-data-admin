module DocumentChildrenHelper
  def parent_document_id(content_id, locale, parent_document_id)
    parent_document_id || "#{content_id}:#{locale}"
  end

  def document_children_link_for(document_id)
    content_data_url = Plek.external_url_for("content-data")
    "#{content_data_url}/documents/#{document_id}/children"
  end
end
