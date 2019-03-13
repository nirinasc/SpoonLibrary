##
# @author nirina
# Singleton Class for storing API Authentication Requests Messages
class APIMessages
  ##
  # define records not found message
  #
  # @param record [#to_s] any object that responds to `#to_s`
  # @return [String] the custom error message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  # define sign in invalid credentials error message
  #
  # @return [String] the custom error message
  def self.invalid_credentials
    'Invalid credentials'
  end

  # define sign in account not active message
  #
  # @return [String] the custom error message
  def self.account_not_active
    'Account not active'
  end

  # define api request invalid token message
  #
  # @return [String] the custom error message
  def self.invalid_token
    'Invalid token'
  end

  # define api request missing token message
  def self.missing_token
    'Missing token'
  end

  # define api request non authorized message
  #
  # @return [String] the custom error message
  def self.unauthorized
    'Unauthorized request'
  end

  # define api request expired token message
  #
  # @return [String] the custom error message
  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end
end
