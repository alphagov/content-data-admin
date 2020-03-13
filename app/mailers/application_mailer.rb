class ApplicationMailer < Mail::Notify::Mailer
  default from: '"GOV.UK Content Data" <no-reply+content-data@digital.cabinet-office.gov.uk>'
  layout false
end
