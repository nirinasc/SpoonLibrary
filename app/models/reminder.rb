class Reminder
  def self.remind_books_return
    # fetch all book loans which due date have passed on
    loans = Log.book_loan.unreturned.over_due_dated.includes(:user, :book).find_each do |loan|
      AdminMailer.book_return_remind(loan).deliver_now
    end
  end
end
