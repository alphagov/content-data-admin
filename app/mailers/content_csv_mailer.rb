class ContentCsvMailer < ApplicationMailer
  def content_csv_email(recipient, csv_link)
    @file_url = csv_link
    mail(to: recipient, subject: "Your GOV.UK Content Data export")
  end
end
