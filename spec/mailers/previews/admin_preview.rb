# Preview all emails at http://localhost:3000/rails/mailers/admin
class AdminPreview < ActionMailer::Preview
    def account_created
        AdminMailer.account_created(User.member.first, "123456789")
    end
    def account_approved
        AdminMailer.account_approved(User.member.first)
    end
    def message
        AdminMailer.notify(recipients: ['john@example.com','erick@example.com'], subject: 'Welcome To Spoon Library', content:'Welcome to our Library!!')
    end
    def book_return_remind
        loan = Log.book_loan.first
        AdminMailer.book_return_remind(loan)
    end
end
