# @author nirina
# Book Mailer class
class BookMailer < ApplicationMailer
  # send an email to a user about the availability of a book
  # @param book [Book] the book to get info from
  # @param user [User] the recipient
  def availability(book:, user:)
    @user = user
    @book = book
    mail(to: user.email, subject: 'Book Availability', template_path: 'book/mailer')
  end
end
