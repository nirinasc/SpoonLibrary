##
# @author nirina
# @api
# @version 1.0
module API::V1
  # V1 API Users Resources
  class UsersController < API::V1::ApplicationController
    # Retrieve current user
    # @example GET /api/users/me
    # @return [ActionDispatch::Response] JSON representation of the current user info
    def me
      render json: current_user, status: :ok
    end
  end
end
