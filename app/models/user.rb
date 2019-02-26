class User < ApplicationRecord

  attr_accessor :approved

  enum role: { member: 0, admin: 1 }

  has_many :comments
  has_many :logs
  has_many :books, through: :logs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :authentication_keys => [:username]
  devise  :registerable, :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\Z/ }
  validates :firstname, presence: true, unless: -> { self.admin? }
  validates :lastname, presence: true, unless: -> { self.admin? }
  validates :country_code, inclusion: { in: ISO3166::Country.all.collect { |country| country.alpha2 } }, allow_nil: true, allow_blank: true
  validates :country_code, presence: true, unless: -> { self.admin? }
  validates :city, presence: true, unless: -> { self.admin? }
  validates :address, presence: true, unless: -> { self.admin? }
  validates :role, inclusion: { in: roles.keys}, allow_nil: true
  validates :active, inclusion: { in: [true, false]}, allow_nil: true 

  before_create :set_default_params

  def active_for_authentication? 
    super && active? 
  end 

  def set_default_params
    self.role ||= User.roles[:member]
    self.active ||= false 
  end

end
