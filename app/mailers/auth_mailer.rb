# @author nirina
# Authentication Mailer class
class AuthMailer < ApplicationMailer
  # send an email to admins about a user request approval
  # @param user [User] the account to approve
  def request_approval(user)
    @resource = user
    mail(to: User.admin.pluck(:email), subject: 'New User Awaiting Admin Approval', template_path: 'auth/mailer')
  end
end
