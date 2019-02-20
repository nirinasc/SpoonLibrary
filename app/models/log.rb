class Log < ApplicationRecord

  enum type: { loan: 0, return: 1 }

  belongs_to :user
  belongs_to :book
  has_one :return, class_name: 'Log', foreign_key: 'loan_id'
  belongs_to :loan, class_name: 'Log', optional: true
end
