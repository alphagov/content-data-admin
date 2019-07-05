RSpec.describe 'routes for documents' do
  it 'routes /documents/:document_id/children to comparison page' do
    expect(get: '/documents/1234:en/children').to route_to(
      controller: 'documents',
      action: 'children',
      document_id: '1234:en'
    )
  end
end
