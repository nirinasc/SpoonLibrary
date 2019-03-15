# @author nirina
class BookMailer < ApplicationMailer
    def availability(book:, user:)
        @user = user
        @book = book
        mail(to: user.email, subject: 'Book Availability', template_path: 'book/mailer')
    end
end