class Book < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged

    enum format: { paper: 0 }
    enum language: { english: 0, french: 1 }

    belongs_to :library
    has_many :comments, dependent: :destroy
    has_many :logs
    has_and_belongs_to_many :categories

    validates :name, presence: true
    validates :isbn, presence: true, length: { maximum: 13 }, uniqueness: true
    validates :number_of_pages, numericality: true, presence: { if: -> { self.paper? } }
    validates :format, presence: true, inclusion: { in: formats.keys } 
    validates_date :pub_date, allow_nil: true
    validates :language, presence: true, inclusion: { in: languages.keys }
    validates :library, presence: true
    validates :categories, presence: true

    mount_uploader :cover_image, ImageUploader

    before_save :set_number_of_pages

    def should_generate_new_friendly_id?
        self.name_changed?
    end

    def set_number_of_pages
        self.number_of_pages = self.number_of_pages ? self.number_of_pages : 0
    end
    
end
