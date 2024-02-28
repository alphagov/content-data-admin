require "govuk_sidekiq/testing"

RSpec.describe CsvExportWorker do
  let(:search_params) do
    {
      date_range: "past-30-days",
      organisation_id: "org-id",
      document_type: "news_story",
    }
  end

  let(:document_types) do
    [{ id: "case_study", name: "Case study" },
     { id: "guide", name: "Guide" },
     { id: "news_story", name: "News story" },
     { id: "html_publication", name: "HTML publication" }]
  end

  let(:organisations) do
    [{ name: "org", id: "org-id", acronym: "OI" },
     { name: "another org", id: "another-org-id" },
     { name: "Users Org", id: "users-org-id", acronym: "UOI" }]
  end

  let(:content_items) do
    [
      {
        title: "GOV.UK homepage",
        base_path: "/",
        organisation_id: nil,
        document_type: "homepage",
        upviews: 15,
        pviews: 25,
        satisfaction: 0.25,
        useful_yes: 100,
        useful_no: 300,
        searches: 14,
        feedex: 24,
        words: 50,
        reading_time: 50,
        pdf_count: 0,
      },
      {
        title: "Title 1",
        base_path: "/base-path-1",
        organisation_id: "another-org-id",
        document_type: "guide",
        upviews: 15,
        pviews: 25,
        satisfaction: 0.6,
        useful_yes: 300,
        useful_no: 200,
        searches: 14,
        feedex: 24,
        words: 100,
        reading_time: 100,
        pdf_count: 3,
      },
    ]
  end

  let(:start_time) { Time.zone.local(2019, 4, 12, 14, 0, 0).to_s }
  # The start time has been converted to a string
  # by the time the Sidekiq worker receives it
  let(:completed_time) { Time.zone.local(2019, 4, 12, 14, 0, 25) }

  before do
    Sidekiq::Worker.clear_all

    ENV["AWS_CSV_EXPORT_BUCKET_NAME"] = "test-bucket"

    allow(FetchDocumentTypes).to receive(:call)
      .and_return(document_types:)
    allow(FetchOrganisations).to receive(:call)
      .and_return(organisations:)
    allow(FindContent).to receive(:enum)
      .with(search_params)
      .and_return(content_items)
    allow(GovukStatsd).to receive(:timing)
  end

  around do |example|
    Timecop.freeze(completed_time) { example.run }
  end

  subject { described_class.new.perform(search_params, "to@example.com", start_time) }

  it "emails a link of the uploaded file" do
    subject

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to[0]).to eq("to@example.com")
    expect(mail.body).to match(/https:\/\/test-bucket\.s3\.amazonaws\.com/)
  end

  it "sends StatsD timing with the milliseconds elapsed" do
    subject

    expect(GovukStatsd).to have_received(:timing).with("monitor.csv.download.ms", 25_000)
  end

  after(:each) do
  end
end
