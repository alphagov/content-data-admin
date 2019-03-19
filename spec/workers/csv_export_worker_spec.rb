require 'govuk_sidekiq/testing'

RSpec.describe CsvExportWorker do
  let(:search_params) do
    {
      date_range: 'past-30-days',
      organisation_id: 'org-id',
      document_type: 'news_story'
    }
  end

  let(:document_types) do
    [{ id: 'case_study', name: 'Case study' },
     { id: 'guide', name: 'Guide' },
     { id: 'news_story', name: 'News story' },
     { id: 'html_publication', name: 'HTML publication' }]
  end

  let(:organisations) do
    [{ name: 'org', id: 'org-id', acronym: 'OI', },
     { name: 'another org', id: 'another-org-id', },
     { name: 'Users Org', id: 'users-org-id', acronym: 'UOI', }]
  end

  let(:content_items) do
    [
      {
        title: 'GOV.UK homepage',
        base_path: '/',
        organisation_id: nil,
        document_type: 'homepage',
        upviews: 15,
        pviews: 25,
        satisfaction: 0.25,
        useful_yes: 100,
        useful_no: 300,
        searches: 14,
        feedex: 24,
        word_count: 50,
        reading_time: 50,
        pdf_count: 0
      },
      {
        title: 'Title 1',
        base_path: '/base-path-1',
        organisation_id: 'another-org-id',
        document_type: 'guide',
        upviews: 15,
        pviews: 25,
        satisfaction: 0.6,
        useful_yes: 300,
        useful_no: 200,
        searches: 14,
        feedex: 24,
        word_count: 100,
        reading_time: 100,
        pdf_count: 3
      }
    ]
  end

  before do
    Sidekiq::Worker.clear_all
  end

  subject { described_class.new.perform(search_params, 'to@example.com') }

  it 'mails a csv' do
    expect(FetchDocumentTypes).to receive(:call).and_return(document_types: document_types)
    expect(FetchOrganisations).to receive(:call).and_return(organisations: organisations)
    expect(FindContent).to receive(:enum)
      .with(search_params)
      .and_return(content_items)

    subject

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to[0]).to eq('to@example.com')
    expect(mail.body).to match('https://somelink.com')
  end
end
