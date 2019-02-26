class AuthMailer < ApplicationMailer
    def request_approval(user)
        @resource = user
        mail(to: User.admin.pluck(:email), subject: 'New User Awaiting Admin Approval',template_path: 'auth/mailer')
    end
end
