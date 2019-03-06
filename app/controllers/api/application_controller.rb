class API::ApplicationController < ActionController::API
    include ResponseHelper
    include API::ExceptionHandler

    before_action :authenticate_request

    attr_reader :current_user
    
    private
    def authenticate_request
        @current_user = AuthorizeJWTRequest.call(request.headers).result
    end
end
