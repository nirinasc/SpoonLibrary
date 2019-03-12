# @author nirina
module API::V1
  # Parent Controller of all V1 API Controller
  class ApplicationController < ActionController::API
    include ActionController::Serialization
    include API::JWTExceptionHandler
    # All API requests need token verfication
    before_action :authenticate_request
    attr_reader :current_user

    private

    # Authenticate the current user by its request token
    # @return [User] the current user there is a match
    # @return [ActionDispatch::Response] JSON with :unauthorized status code if the user matched is not active
    # @return [ActionDispatch::Response] JSON with :unprocessable_entity status code
    #   if the request auth header token is invalid
    def authenticate_request
      # User AuthorizeJWTRequest.call to authorize the user
      @current_user = AuthorizeJWTRequest.call(request.headers).result
    end
  end
end
