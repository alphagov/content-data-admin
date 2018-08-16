RSpec.describe '/metrics/base/path', type: :feature do
  include GdsApi::TestHelpers::ContentDataApi
  let(:metrics_response) do
    {}
  end

  it 'renders the metric for unique_pageviews' do
    content_api_has_metric('base/path',
                           'unique_pageviews',
                           '2000-01-01',
                           '2050-01-01',
                           unique_pageviews: { total: 145_000 })
    visit '/metrics/unique_pageviews/base/path?from=2000-01-01&to=2050-01-01'
    expect(page).to have_content('Metrics')
    expect(page).to have_content('145000')
  end
end
