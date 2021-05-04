class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.mail_id
  layout 'mailer'
end
