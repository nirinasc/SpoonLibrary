class Book < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessor :previous_status

  enum status: { untouched: 0, borrowed: 1, returned: 2 }
  enum format: { paper: 0 }
  enum language: { english: 0, french: 1 }

  belongs_to :library
  has_many :comments, dependent: :destroy
  has_many :logs
  has_and_belongs_to_many :categories

  scope :available, -> { where(available: true) }
  scope :unavailable, -> { where(available: false) }

  validates :name, presence: true
  validates :isbn, presence: true, length: { maximum: 13 }, uniqueness: true
  validates :number_of_pages, numericality: true, presence: { if: -> { paper? } }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :format, presence: true, inclusion: { in: formats.keys }
  validates_date :pub_date, allow_nil: true
  validates :language, presence: true, inclusion: { in: languages.keys }
  validates :library, presence: true
  validates :categories, presence: true

  mount_uploader :cover_image, ImageUploader

  before_save :set_number_of_pages
  before_update :set_previous_status
  after_update :register_loan, if: -> { status == Book.statuses.key(1) && previous_status != Book.statuses.key(1) }

  def should_generate_new_friendly_id?
    name_changed?
  end

  def set_number_of_pages
    self.number_of_pages = number_of_pages || 0
  end

  def set_previous_status
    self.previous_status = Book.find(id).status
  end

  def register_loan
    Log.create(
      user: User.current,
      book: self,
      classification: Log.classifications[:book_loan],
      date: DateTime.now,
      due_date: 3.weeks.from_now
    )
    self.previous_status = status
  end

  def last_loan
    logs.book_loan.last
  end
end
