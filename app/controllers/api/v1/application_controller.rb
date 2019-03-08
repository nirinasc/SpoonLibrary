module API::V1
    class ApplicationController < ActionController::API

        include ActionController::Serialization
        
        include API::JWTExceptionHandler
    
        before_action :authenticate_request
    
        attr_reader :current_user
        
        private
        def authenticate_request
            @current_user = AuthorizeJWTRequest.call(request.headers).result
        end
    end
end


