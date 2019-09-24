RSpec.describe ContentCsvMailer, type: :mailer do
  describe "content_csv_email" do
    let(:mail) { ContentCsvMailer.content_csv_email("to@example.org", "https://link-to-file.com") }

    it "renders the headers" do
      expect(mail.subject).to eq("Your GOV.UK Content Data export")
      expect(mail.from).to eq(["no-reply-content-data@digital.cabinet-office.gov.uk"])
      expect(mail.to).to eq(["to@example.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("The data you exported from Content Data will be available from this link for 7 days.")
    end

    it "contains the link" do
      expect(mail.body.encoded).to match("https://link-to-file.com")
    end
  end
end
