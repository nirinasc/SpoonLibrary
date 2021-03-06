# @author nirina
# Tableless Message model which represent an email
class Message
  include ActiveModel::Model
  attr_accessor :subject, :content, :recipients

  validates :subject, presence: true
  validates :content, presence: true
  validates :recipients, presence: true
end
