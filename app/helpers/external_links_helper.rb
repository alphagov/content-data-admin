module ExternalLinksHelper
  def edit_url_for(content_id:, publishing_app:)
    case publishing_app
    when 'whitehall'
      "#{external_url_for('whitehall-admin')}/government/admin/by-content-id/#{content_id}"
    when 'publisher'
      "#{external_url_for('support')}/content_change_request/new"
    when 'manuals-publisher'
      "#{external_url_for('manuals-publisher')}/manuals/#{content_id}"
    when 'maslow', 'need-api'
      "#{external_url_for('maslow')}/needs/#{content_id}"
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
end
