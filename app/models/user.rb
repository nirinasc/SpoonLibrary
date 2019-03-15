# @author nirina
# User Model Class
class User < ApplicationRecord
  attr_accessor :approved

  # user roles enumeration
  enum role: { member: 0, admin: 1 }

  # retrieve all incative users
  scope :inactive, -> { where(active: false) }

  # a user has many comments
  has_many :comments
  # a user ha many logs
  has_many :logs
  # a user has many books through logs
  has_many :books, through: :logs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, authentication_keys: [:username]
  devise :registerable, :recoverable, :rememberable, :validatable

  # user validation rules
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username,
            presence: true,
            uniqueness: true,
            format: { with: /\A[a-zA-Z0-9_]+\Z/, message: 'can only contain alphanumeric characters and dashes' }
  validates :firstname, presence: true, unless: -> { admin? }
  validates :lastname, presence: true, unless: -> { admin? }
  validates :country_code, inclusion: { in: ISO3166::Country.all.collect(&:alpha2) }, allow_nil: true, allow_blank: true
  validates :country_code, presence: true, unless: -> { admin? }
  validates :city, presence: true, unless: -> { admin? }
  validates :address, presence: true, unless: -> { admin? }
  validates :role, inclusion: { in: roles.keys }, allow_nil: true
  validates :active, inclusion: { in: [true, false] }, allow_nil: true

  # before creation, ensure default params are set
  before_create :set_default_params

  # check if a user is active
  # @return [Boolean] the result
  def active_for_authentication?
    super && active?
  end

  # set default role and active
  # @return [void]
  def set_default_params
    self.role ||= User.roles[:member]
    self.active ||= true
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end
end
