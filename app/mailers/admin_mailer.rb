class AdminMailer < ApplicationMailer

    default template_path:  'admin/mailer'

    def account_created(user,password)
        @user = user
        @password = password
        mail(to: user.email, subject: "An account has been created for you")

    end

    def account_approved(user)
        @user = user
        mail(to: user.email, subject: "Your account has been approved")
    end
end
