RSpec.describe 'routes for Content' do
  it 'routes /content to Content' do
    expect(get('/content')).to route_to('content#index')
  end

  it 'does not route /content/<id>' do
    expect(get('/content/1')).not_to be_routable
  end
end
