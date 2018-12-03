RSpec.describe ExternalLinksHelper do
  describe '#edit_url_for' do
    context 'with a known publishing app' do
      it 'generates an expected URL' do
        expect(
          edit_url_for(content_id: 'content_id', publishing_app: 'whitehall', base_path: '/base-path', document_type: 'news_story')
        ).to eq(
          "#{Plek.new.external_url_for('whitehall-admin')}/government/admin/by-content-id/content_id"
        )
      end
    end

    context 'with publisher' do
      it 'generates a link to the Support app' do
        expect(
          edit_url_for(content_id: 'content_id', publishing_app: 'publisher', base_path: '/base-path', document_type: 'news_story')
        ).to eq(
          "#{Plek.new.external_url_for('support')}/content_change_request/new"
        )
      end
    end

    context 'with contacts' do
      it 'generates a link to the contacts publisher app' do
        expect(
          edit_url_for(content_id: 'content_id',
                       publishing_app: 'contacts',
                       base_path: 'government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line',
                       document_type: 'news_story')
        ).to eq(
          "#{external_url_for('contacts-admin')}/admin/contacts/tax-credits-agent-priority-line/edit"
        )
      end
    end

    context 'with specialist-publisher' do
      it 'generates a link to the specialist publisher app with document_type' do
        expect(
          edit_url_for(content_id: 'spec-pub-id',
                       publishing_app: 'specialist-publisher',
                       base_path: 'government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line',
                       document_type: 'service_standard_report')
        ).to eq(
          "#{external_url_for('specialist-publisher')}/service-standard-reports/spec-pub-id/edit"
        )

        expect(
          edit_url_for(content_id: 'spec-pub-id',
                       publishing_app: 'specialist-publisher',
                       base_path: 'government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line',
                       document_type: 'aaib_report')
        ).to eq(
          "#{external_url_for('specialist-publisher')}/aaib-reports/spec-pub-id/edit"
        )
      end
    end

    context 'with collections' do
      it 'generates a link to the collections publisher app' do
        expect(
          edit_url_for(content_id: 'coll-pub-id',
                       publishing_app: 'collections-publisher',
                       base_path: 'government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line',
                       document_type: 'news_story')
        ).to eq(
          "#{external_url_for('support')}/content_change_request/new"
        )
      end
    end

    context 'with travel advice' do
      it 'generates a link to the collections publisher app' do
        expect(
          edit_url_for(content_id: 'ta-pub-id',
                       publishing_app: 'travel-advice-publisher',
                       base_path: '/foreign-travel-advice/brunei',
                       document_type: 'news_story')
        ).to eq(
          "#{external_url_for('travel-advice-publisher')}/admin/countries/brunei"
        )
      end
    end

    context 'with an unknown publishing app' do
      it 'returns nil' do
        expect(
          edit_url_for(content_id: 'content_id', publishing_app: 'not-an-app', base_path: '/base-path', document_type: 'news_story')
        ).to eq(
          nil
        )
      end
    end
  end

  describe '#edit_label_for' do
    context 'with a known publishing app' do
      it 'generates the expected label' do
        expect(
          edit_label_for(publishing_app: 'whitehall')
        ).to eq(
          'Edit in Whitehall'
        )
      end
    end

    context 'with publisher' do
      it 'uses the specific label' do
        expect(
          edit_label_for(publishing_app: 'publisher')
        ).to eq(
          'Request a content change in GOV.UK Support'
        )
      end
    end
  end
end
