# @author nirina
# Parent Mailer class
# Set default parms for all child class
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@spoonlibrary.com'
  layout 'mailer'
end
