RSpec.feature 'link to document children' do
  include RequestStubs

  scenario 'content has no children pages' do
    stub_metrics_page(base_path: nil, time_period: :past_30_days)
    visit '/metrics?date_range=past-30-days'

    expect(page).to have_no_link('See data for all sections')
  end

  scenario 'content is parent of 2 pages' do
    stub_metrics_page(base_path: nil, time_period: :past_30_days, related_content: 3)
    visit '/metrics?date_range=past-30-days'

    link = Plek.new.external_url_for('content-data') + '/documents/content-id:fr/children'
    expect(page).to have_link('See data for all sections', href: link)
  end

  scenario 'content is child of 2 pages' do
    stub_metrics_page(
      base_path: nil,
      time_period: :past_30_days,
      related_content: 3,
      parent_document_id: '1234:en'
    )
    visit '/metrics?date_range=past-30-days'

    link = Plek.new.external_url_for('content-data') + '/documents/1234:en/children'
    expect(page).to have_link('See data for all sections', href: link)
  end
end
