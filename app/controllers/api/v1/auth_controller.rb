# @author nirina
# @api
# @version 1.0
module API::V1
  # V1 API Authentication Resources
  class AuthController < API::V1::ApplicationController
    skip_before_action :authenticate_request

    # Log a user by its username and password
    # @example POST /api/auth/login with request params {:username => 'demo', :password: 'demo'}
    # @return [ActionDispatch::Response] JSON representation of the auth token if the user is authenticated
    # @return [ActionDispatch::Response] JSON with :unauthorized status code if the user matched is not active
    # @return [ActionDispatch::Response] JSON with :bad_request status code if credentials are no valid
    def login
      # Call JWTAuthenticateUser Command to authenticate user credentials
      command = JWTAuthenticateUser.call(auth_params[:username], auth_params[:password])
      render json: { auth_token: command.result }, status: :ok
    end

    private

    # @example auth_params => {:username => "demo", :password: "demo"}
    # @return [Hash], the login required params
    def auth_params
      params.require(:auth).permit(:username, :password)
    end
  end
end
