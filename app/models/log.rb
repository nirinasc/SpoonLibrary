class Log < ApplicationRecord
  enum classification: { book_loan: 0, book_return: 1 }

  belongs_to :user
  belongs_to :book
  has_one :return, class_name: 'Log', foreign_key: 'loan_id', dependent: :destroy
  belongs_to :loan, class_name: 'Log', optional: true

  scope :unreturned, -> { where(returned: false) }
  scope :over_due_dated, -> { where('due_date < ?', DateTime.now) }

  validates :classification, inclusion: { in: classifications.keys }
  validates :loan, presence: { if: -> { book_return? } }, absence: { if: -> { book_loan? } }
  validates :loan, uniqueness: true, loan: { returned: false, message: 'The book has been already returned' }, allow_nil: true
  validates_presence_of :date
  validates_datetime :date, if: -> { book_loan? }
  validates_datetime :date, after: :associated_loan_date, if: -> { book_return? }
  validates_presence_of :due_date, if: -> { book_loan? }
  validates_datetime :due_date, after: :date, if: -> { book_loan? }
  validates :returned, inclusion: { in: [true, false] }, allow_nil: true
  validates :book, book: { available: true, message: 'The book is not available' }, if: -> { book_loan? }, on: :create

  before_save :set_book_return_defaults, if: -> { book_return? }
  after_create :return_referenced_loan, if: -> { book_return? }
  after_create :set_book_available, if: -> { book_return? }
  before_destroy :unreturn_referenced_loan, if: -> { book_return? }
  before_destroy :set_book_available, if: :the_last_book_return?
  after_create :set_book_unavailable, if: -> { book_loan? }

  def set_book_return_defaults
    self.user = loan.user
    self.book = loan.book
    self.returned = true
  end

  def return_referenced_loan
    loan.update_attributes(returned: true)
  end

  def unreturn_referenced_loan
    loan.update_attributes(returned: false)
  end

  def set_book_unavailable
    book.update_attributes(available: false)
  end

  def set_book_available
    book.update_attributes(available: true)
  end

  def to_s
    book_loan? ? "#{book.name} Book Loan ##{date}" : "#{book.name} Book Return ##{date}"
  end

  private

  def associated_loan_date
    loan.date
  end

  private

  def the_last_book_return?
    if book_return?
      last_book_return = Log.book_return.includes(:book).where(book: book).last
      last_book_return.present?
    else
      false
    end
  end
end
