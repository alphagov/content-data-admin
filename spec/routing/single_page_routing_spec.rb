RSpec.describe '/metrics routing' do
  it 'routes correctly with given base path' do
    expect(get: '/metrics/long/base/path?date_range=past-30-days').to route_to(
      controller: 'single_page',
      action: 'show',
      base_path: 'long/base/path',
      date_range: 'past-30-days'
    )
  end

  it 'generates a route for the given base_path' do
    expect(get: single_page_path('/base/path', date_range: 'past-30-days')).to route_to(
      controller: 'single_page',
      action: 'show',
      base_path: 'base/path',
      date_range: 'past-30-days'
    )
  end

  it 'routes correctly without a base path for the homepage' do
    expect(get: '/metrics?date_range=last-month').to route_to(
      controller: 'single_page',
      action: 'show',
      date_range: 'last-month'
    )
  end

  it 'generates a route for the homepage' do
    expect(get: single_page_path(date_range: 'past-30-days')).to route_to(
      controller: 'single_page',
      action: 'show',
      date_range: 'past-30-days'
    )
  end
end
