# @author nirina
# Admin Mailer class
class AdminMailer < ApplicationMailer
  default template_path: 'admin/mailer'

  # send an email to a new user who was created from admin panel
  # @param user [User] the recipient
  # @param password [String] the user password
  def account_created(user, password)
    @user = user
    @password = password
    mail(to: user.email, subject: 'An account has been created for you')
  end

  # account validation email callback
  # @param user [User] the recipient
  def account_approved(user)
    @user = user
    mail(to: user.email, subject: 'Your account has been approved')
  end

  # send a notification to a group of users
  # @param recipients [Array<String>] the recipients email lists
  # @param subject [String] the email subject
  # @param content [String] the email main content
  def notify(recipients:, subject:, content:)
    @content = content
    mail(to: recipients, subject: subject)
  end

  # send a loan due date reminder email
  # @param loan [Log] the book loan to remind due date from
  def book_return_remind(loan)
    @loan = loan
    mail(to: loan.user.email, subject: "#{loan.book.name} Book Loan Due Date Passed")
  end
end
