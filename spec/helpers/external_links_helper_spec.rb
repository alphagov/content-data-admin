RSpec.describe ExternalLinksHelper do
  describe '#edit_url_for' do
    context 'with a known publishing app' do
      it 'generates an expected URL' do
        expect(
          edit_url_for(content_id: 'content_id', publishing_app: 'whitehall')
        ).to eq(
          "#{Plek.new.external_url_for('whitehall-admin')}/government/admin/by-content-id/content_id"
        )
      end
    end

    context 'with publisher' do
      it 'generates a link to the Support app' do
        expect(
          edit_url_for(content_id: 'content_id', publishing_app: 'publisher')
        ).to eq(
          "#{Plek.new.external_url_for('support')}/content_change_request/new"
        )
      end
    end

    context 'with an unknown publishing app' do
      it 'returns nil' do
        expect(
          edit_url_for(content_id: 'content_id', publishing_app: 'not-an-app')
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
