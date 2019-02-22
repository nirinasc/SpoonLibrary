class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :content, presence: true, length: { minimum: 2 }

end
