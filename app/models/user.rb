class User < ApplicationRecord
  
  enum role: { member: 0, admin: 1 }

  has_many :comments
  has_many :logs
  has_many :books, through: :logs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :authentication_keys => [:username]
  devise  :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\Z/ }
  validates :role, presence: true, inclusion: { in: roles.keys}
  validates :active, inclusion: { in: [true, false]} 


end
