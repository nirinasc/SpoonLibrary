class Log < ApplicationRecord

  enum classification: { book_loan: 0, book_return: 1 }

  belongs_to :user
  belongs_to :book
  has_one :return, class_name: 'Log', foreign_key: 'loan_id'
  belongs_to :loan, class_name: 'Log', optional: true

  validates :classification, inclusion: { in: classifications.keys }
  validates :loan, presence: { if: -> { self.book_return? } }, absence: { if: -> { self.book_loan? }}
  validates_presence_of :date
  validates_datetime :date, if: -> { self.book_loan? }
  validates_datetime :date, after: :associated_loan_date, if: -> { self.book_return? }
  validates_presence_of :due_date, if: -> { self.book_loan? } 
  validates_datetime :due_date, after: :date, if: -> { self.book_loan? }
  validates :returned, inclusion: { in: [true, false] }

  def associated_loan_date
    self.loan.date
  end
end
