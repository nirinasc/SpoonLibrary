class JWTAuthenticateUser
    prepend SimpleCommand
  
    def initialize(username, password)
      @username = username
      @password = password
    end
  
    def call
      JsonWebToken.encode(user_id: user.id) if user
    end
  
    private
  
    attr_accessor :username, :password
  
    def user
      user = User.find_by_username(username)
      return user if user && user.valid_password?(password)
  
      raise(API::ExceptionHandler::AuthenticationError, APIMessages.invalid_credentials)
    end
end