class API::AuthController < API::ApplicationController
    
    skip_before_action :authenticate_request

    # return auth token once user is authenticated
    def login
      command  = JWTAuthenticateUser.call(auth_params[:username], auth_params[:password])
      json_response(auth_token: command.result)
    end
  
    private
  
    def auth_params
      params.require(:auth).permit(:username, :password)
    end
end