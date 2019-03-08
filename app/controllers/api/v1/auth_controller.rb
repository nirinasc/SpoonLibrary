module API::V1
  class AuthController < API::V1::ApplicationController
    
      skip_before_action :authenticate_request

      # return auth token once user is authenticated
      def login
        command  = JWTAuthenticateUser.call(auth_params[:username], auth_params[:password])
        render json: { auth_token: command.result } , status: :ok
      end
    
      private
    
      def auth_params
        params.require(:auth).permit(:username, :password)
      end
  end
end
