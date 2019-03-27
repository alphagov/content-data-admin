require 'govuk_sidekiq/testing'

RSpec.describe 'Exporting CSV' do
  include RequestStubs
  let(:items) do
    [
      {
        base_path: '/',
        title: 'GOV.UK homepage',
  organisation_id: 'org-id',
        upviews: 1_233_018,
        document_type: 'homepage',
        satisfaction: 0.85,
        useful_yes: 85,
        useful_no: 15,
        searches: 1220,
        reading_time: 50
      },
      {
        base_path: '/path/1',
        title: 'The title',
  organisation_id: 'org-id',
        upviews: 233_018,
        document_type: 'news_story',
        satisfaction: 0.813,
        useful_yes: 813,
        useful_no: 187,
        searches: 220,
        reading_time: 50
      },
      {
        base_path: '/path/2',
        title: 'Another title',
  organisation_id: 'org-id',
        upviews: 100_018,
        document_type: 'guide',
        satisfaction: 0.68,
        useful_yes: 34,
        useful_no: 16,
        searches: 12,
        reading_time: 50
      }
    ]
  end

  before(:each) do
    pending("something else getting finished")
    stub_content_page(time_period: 'past-30-days', organisation_id: 'all', items: items)
    stub_content_page_csv_download(time_period: 'past-30-days', organisation_id: 'all', items: items)
    GDS::SSO.test_user = build(:user, organisation_content_id: 'users-org-id', email: 'to@example.com')

    Fog.mock!
    ENV['AWS_REGION'] = 'eu-west-1'
    ENV['AWS_ACCESS_KEY_ID'] = 'test'
    ENV['AWS_SECRET_ACCESS_KEY'] = 'test'
    ENV['AWS_CSV_EXPORT_BUCKET_NAME'] = 'test-bucket'

    # Create an S3 bucket so the code being tested can find it
    connection = Fog::Storage.new(
      provider: 'AWS',
      region: ENV['AWS_REGION'],
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    connection.directories.each(&:destroy)
    @directory = connection.directories.create(key: ENV['AWS_CSV_EXPORT_BUCKET_NAME'])

    visit "/content"
    click_link('Download all data in CSV format')
  end

  it 'renders the page without error' do
    expect(page.status_code).to eq(200)
    expect(page).to have_content('Sending the CSV export')
    expect(page).to have_content('to@example.com')
  end

  it 'uploads the file' do
    csv = CSV.parse(@directory.files.first.body)
    expect(csv.length).to eq(4)
  end

  it 'sends a email with link to CSV export' do
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to[0]).to eq('to@example.com')
    expect(mail.body.to_s).to match(@directory.files.first.public_url)
  end

  after(:each) do
    Fog::Mock.reset
  end
end
