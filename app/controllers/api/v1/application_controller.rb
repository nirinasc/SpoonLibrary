module API::V1
  # Parent Controller of all V1 API Controller
  class ApplicationController < ActionController::API
    include ActionController::Serialization
    include API::JWTExceptionHandler
    # All API requests need token verfication
    before_action :authenticate_request
    attr_reader :current_user

    private

    # Authenticate the current token by its token
    # Return the current user there is a match
    def authenticate_request
      @current_user = AuthorizeJWTRequest.call(request.headers).result
    end
  end
end
