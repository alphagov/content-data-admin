module ExternalLinksHelper
  def edit_url_for(content_id:, publishing_app:, base_path:)
    case publishing_app
    when 'whitehall'
      "#{external_url_for('whitehall-admin')}/government/admin/by-content-id/#{content_id}"
    when 'publisher'
      "#{external_url_for('support')}/content_change_request/new"
    when 'manuals-publisher'
      "#{external_url_for('manuals-publisher')}/manuals/#{content_id}"
    when 'maslow', 'need-api'
      "#{external_url_for('maslow')}/needs/#{content_id}"
    when 'contacts'
      "#{external_url_for('contacts-admin')}/admin/contacts/#{slug_from_basepath(base_path)}/edit"
    when 'specialist-publisher'
      "#{external_url_for('specialist-publisher')}/service-standard-reports/#{content_id}/edit"
    when 'collections-publisher'
      "#{external_url_for('support')}/general_request/new"
    when 'travel-advice-publisher'
      "#{external_url_for('travel-advice-publisher')}/admin/#{slug_from_basepath(base_path)}"
    end
  end

  def edit_label_for(publishing_app:)
    return nil if publishing_app.blank?

    case publishing_app
    when 'publisher'
      I18n.t('metrics.show.navigation.publisher_edit_link')
    else
      I18n.t(
        'metrics.show.navigation.edit_link',
        publishing_app: publishing_app.capitalize.tr('-', ' ')
      )
    end
  end

  def external_url_for(service)
    Plek.new.external_url_for(service)
  end

  def slug_from_basepath(base_path)
    base_path.split('/').last
  end
end
