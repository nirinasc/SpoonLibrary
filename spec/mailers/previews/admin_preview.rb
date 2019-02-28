# Preview all emails at http://localhost:3000/rails/mailers/admin
class AdminPreview < ActionMailer::Preview
    def account_created
        AdminMailer.account_created(User.member.first, "123456789")
    end
    def account_approved
        AdminMailer.account_approved(User.member.first)
    end
end
