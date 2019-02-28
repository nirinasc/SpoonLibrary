class Log < ApplicationRecord

  enum classification: { book_loan: 0, book_return: 1 }

  belongs_to :user
  belongs_to :book
  has_one :return, class_name: 'Log', foreign_key: 'loan_id', dependent: :destroy
  belongs_to :loan, class_name: 'Log', optional: true

  scope :unreturned, -> { where(returned: false) }

  validates :classification, inclusion: { in: classifications.keys }
  validates :loan, presence: { if: -> { self.book_return? } }, absence: { if: -> { self.book_loan? }}
  validates :loan, uniqueness: true, loan: true, allow_nil: true 
  validates_presence_of :date
  validates_datetime :date, if: -> { self.book_loan? }
  validates_datetime :date, after: :associated_loan_date, if: -> { self.book_return? }
  validates_presence_of :due_date, if: -> { self.book_loan? } 
  validates_datetime :due_date, after: :date, if: -> { self.book_loan? }
  validates :returned, inclusion: { in: [true, false] }, allow_nil: true

  before_save :set_defaults, if: -> { self.book_return? }
  after_save :check_referenced_loan, if: -> { self.book_return? }
  before_destroy :uncheck_referenced_loan, if: -> { self.book_return? }

  def set_defaults
    self.user = self.loan.user
    self.book = self.loan.book
    self.returned = true
  end

  def check_referenced_loan
    self.loan.update_attributes({returned: true})
  end

  def uncheck_referenced_loan
    self.loan.update_attributes({returned: false})
  end

  def to_s
    self.book_loan? ? "#{self.book.name} Book Loan ##{self.date}" : "#{self.book.name} Book Return ##{self.date}"
  end

  private
  def associated_loan_date
    self.loan.date
  end
end
