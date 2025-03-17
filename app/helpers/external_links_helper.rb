module ExternalLinksHelper
  def edit_url_for(content_id:, publishing_app:, base_path:, document_type:, parent_content_id: "", locale: "en")
    case publishing_app
    when "whitehall"
      "#{external_url_for('whitehall-admin')}/government/admin/by-content-id/#{content_id}"
    when "publisher"
      "#{external_url_for('support')}/content_change_request/new"
    when "content-publisher"
      "#{external_url_for('content-publisher')}/documents/#{content_id}:#{locale}"
    when "manuals-publisher"
      case document_type
      when "manual"
        "#{external_url_for('manuals-publisher')}/manuals/#{content_id}"
      when "manual_section"
        "#{external_url_for('manuals-publisher')}/manuals/#{parent_content_id}/sections/#{content_id}"
      end
    when "maslow", "need-api"
      "#{external_url_for('maslow')}/needs/#{content_id}"
    when "contacts"
      "#{external_url_for('contacts-admin')}/admin/contacts/#{slug_from_basepath(base_path)}/edit"
    when "specialist-publisher"
      "#{external_url_for('specialist-publisher')}/#{specialist_publisher_path(document_type, content_id)}"
    when "collections-publisher"
      "#{external_url_for('support')}/content_change_request/new"
    when "travel-advice-publisher"
      "#{external_url_for('travel-advice-publisher')}/admin/countries/#{slug_from_basepath(base_path)}"
    end
  end

  def edit_label_for(publishing_app:)
    return nil if publishing_app.blank?

    case publishing_app
    when "publisher"
      I18n.t("metrics.show.navigation.publisher_edit_link")
    when "collections-publisher"
      I18n.t("metrics.show.navigation.request_change_link")
    else
      I18n.t(
        "metrics.show.navigation.edit_link",
        publishing_app: publishing_app.tr("-", " ").titlecase,
      )
    end
  end

  def feedex_url(from:, to:, base_path:)
    host = Plek.external_url_for("support")
    path = CGI.escape(base_path)
    base_request = "#{host}/anonymous_feedback?from=#{from}&to=#{to}&paths=#{path}"
    if base_path == "/"
      "#{base_request}&document_type=homepage"
    else
      base_request
    end
  end

  delegate :external_url_for, to: :Plek

  def slug_from_basepath(base_path)
    base_path.split("/").last
  end

  def specialist_publisher_path(document_type, content_id)
    formatted_document_type = "#{document_type.tr('_', '-')}s"
    "#{formatted_document_type}/#{content_id}/edit"
  end
end
