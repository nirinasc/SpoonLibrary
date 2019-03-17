# @author nirina
# Library Model
class Library < ApplicationRecord
  # a Library has many books
  has_many :books

  # validation rules
  validates :name, presence: true
  validates :country_code, presence: true, inclusion: { in: ISO3166::Country.all.collect(&:alpha2) }
  validates :city, presence: true
  validates :address, presence: true
end
