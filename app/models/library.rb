class Library < ApplicationRecord
    has_many :books

    validates :name, presence: true
    validates :country_code, presence: true
    validates :city, presence: true
    validates :address, presence: true
    
end
