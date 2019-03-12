##
# @author nirina
# JWT API Request User Authenticator Command Class
# @see https://github.com/nebulab/simple_command
class JWTAuthenticateUser
  prepend SimpleCommand

  # The Command Class Initializer
  # @param [String] the user username
  # @param [String] the user password
  def initialize(username, password)
    @username = username
    @password = password
  end

  # Generate an auth token from the authenticated user id
  # @return [String] the authorization token if the authentication is successfull
  # @raise [API::JWTExceptionHandler::AuthenticationError] if credentails are invalid
  # @raise [API::JWTExceptionHandler::InactiveAccount] if the matched user is not active
  def call
    # encode the user id to a JWT token
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :username, :password

  # Retrieve a user from the username and password
  # @return [User] the authenticated User if its exists
  # @raise [API::JWTExceptionHandler::AuthenticationError] if credentails are invalid
  # @raise [API::JWTExceptionHandler::InactiveAccount] if the matched user is not active
  def user
    # Find a user by its username
    user = User.find_by_username(username)

    if user&.valid_password?(password)
      # return the user if its password is valid and the user is active
      return user if user.active

      # Else Raise an API::JWTExceptionHandler::InactiveAccount Exception Message
      raise(API::JWTExceptionHandler::InactiveAccount, APIMessages.account_not_active)
    end
    # Raise an (API::JWTExceptionHandler::AuthenticationError Exception Message 
    # if the password is not valid or there is no user found
    raise(API::JWTExceptionHandler::AuthenticationError, APIMessages.invalid_credentials)
  end
end
