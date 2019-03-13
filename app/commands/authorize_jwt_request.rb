##
# @author nirina
# JWT API Request Authorization Handler Command Class
# @see https://github.com/nebulab/simple_command
class AuthorizeJWTRequest
  prepend SimpleCommand

  # Class Initializer
  # @params [Hash, nil] the request headers
  # @option headers [String] :Authorization The auth header 
  def initialize(headers = {})
    @headers = headers
  end

  # The command call method
  # @see #user
  def call
    user
  end

  private

  attr_reader :headers

  # Retrieve a user from the auth token included in headers
  # @return [User] the matched User
  # @raise [API::JWTExceptionHandler::InactiveAccount] if the user account matched is not active
  # @raise [API::JWTExceptionHandler::InvalidToken] if the token is invalid
  def user
    # find a User matching the decoded token if the decode operation was successfull
    user = User.find(decoded_auth_token[:user_id]) if decoded_auth_token

    if user
      # return the user if active
      return user if user.active

      # Else raise a JWTException Inactive Account
      raise(API::JWTExceptionHandler::InactiveAccount, APIMessages.account_not_active)
    end
  rescue ActiveRecord::RecordNotFound => e
    # Raise an Invalid Token if there is no matching User from db
    raise(API::JWTExceptionHandler::InvalidToken, ("#{APIMessages.invalid_token} #{e.message}"))
  end

  # decode auth token using JsonWebToken
  # @example
  #   decode_auth_token #=> { :user_id => 1, :exp => 1515125}
  # @return [Hash] the result payload
  # @raise [API::JWTExceptionHandler::InvalidToken] if token invalid
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # pull Authorization token from header
  # @return [String]
  # @raise [API::JWTExceptionHandler::MissingToken] if token missing
  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    raise(API::JWTExceptionHandler::MissingToken, APIMessages.missing_token)
  end
end
