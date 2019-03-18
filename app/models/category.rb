# @author nirina
# Category Model class
class Category < ApplicationRecord
  # a Category belongs to many books
  has_and_belongs_to_many :books

  # validation rules
  validates :name, presence: true, length: { minimum: 2 }
end
