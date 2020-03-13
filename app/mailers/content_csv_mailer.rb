class ContentCsvMailer < ApplicationMailer
  def content_csv_email(recipient, csv_link)
    @file_url = csv_link
    view_mail(template_id, to: recipient, subject: "Your GOV.UK Content Data export")
  end

  def template_id
    @template_id ||= ENV.fetch("GOVUK_NOTIFY_TEMPLATE_ID", "fake-test-template-id")
  end
end
