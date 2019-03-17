# Preview all emails at http://localhost:3000/rails/mailers/book
class BookPreview < ActionMailer::Preview
  def availability
    BookMailer.availability(book: Book.borrowed.first, user: User.member.first)
  end
end
