class Library < ApplicationRecord
    has_many :books

    validates :name, presence: true
    validates :country_code, presence: true, inclusion: { in: ISO3166::Country.all.collect { |country| country.alpha2 } }
    validates :city, presence: true
    validates :address, presence: true
    
end
