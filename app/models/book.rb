class Book < ApplicationRecord
    belongs_to :library
    has_many :comments
    has_many :logs
    has_and_belongs_to_many :categories
end
