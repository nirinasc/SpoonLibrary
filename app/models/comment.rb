# @author nirina
# Comment Model class
class Comment < ApplicationRecord
  # a comment is performed by a user
  belongs_to :user
  # a comment is about a book
  belongs_to :book, counter_cache: true

  # validation rules
  validates :content, presence: true, length: { minimum: 2 }
end
