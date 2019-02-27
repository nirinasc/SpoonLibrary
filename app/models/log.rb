class Log < ApplicationRecord

  enum classification: { book_loan: 0, book_return: 1 }

  belongs_to :user
  belongs_to :book
  has_one :return, class_name: 'Log', foreign_key: 'loan_id', dependent: :destroy
  belongs_to :loan, class_name: 'Log', optional: true

  validates :classification, inclusion: { in: classifications.keys }
  validates :loan, presence: { if: -> { self.book_return? } }, absence: { if: -> { self.book_loan? }}, uniqueness: true 
  validates_presence_of :date
  validates_datetime :date, if: -> { self.book_loan? }
  validates_datetime :date, after: :associated_loan_date, if: -> { self.book_return? }
  validates_presence_of :due_date, if: -> { self.book_loan? } 
  validates_datetime :due_date, after: :date, if: -> { self.book_loan? }
  validates :returned, inclusion: { in: [true, false] }

  before_save :set_owners, if: -> { self.book_return? } 


  def set_owners 
    self.user = self.loan.user
    self.book = self.loan.book
  end

  def to_s
    self.book_loan? ? "#{self.book.name} Book Loan ##{self.date}" : "#{self.book.name} Book Return ##{self.date}"
  end

  private
  def associated_loan_date
    self.loan.date
  end
end
