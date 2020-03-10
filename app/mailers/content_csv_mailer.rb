class ContentCsvMailer < Mail::Notify::Mailer
  def content_csv_email(recipient, csv_link)
    @file_url = csv_link
    view_mail(ENV.fetch("GOVUK_NOTIFY_TEMPLATE_ID", "fake-test-template-id"),
              to: recipient,
              subject: "Your GOV.UK Content Data export")
  end
end
