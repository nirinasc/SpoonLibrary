class Book < ApplicationRecord

    enum format: { paper: 0 }
    enum language: { english: 0, french: 1 }

    belongs_to :library
    has_many :comments
    has_many :logs
    has_and_belongs_to_many :categories
end
