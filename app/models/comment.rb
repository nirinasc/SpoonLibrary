class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :book, counter_cache: true

  validates :content, presence: true, length: { minimum: 2 }
end
