# @author nirina
# Reminder Tasks class
class Reminder
  # remind users who didn't return books before loans due date
  def self.remind_books_return
    # fetch all book loans which due date have passed on
    Log.book_loan.unreturned.over_due_dated.includes(:user, :book).find_each do |loan|
      # send reminder email
      AdminMailer.book_return_remind(loan).deliver_now
    end
  end
end
