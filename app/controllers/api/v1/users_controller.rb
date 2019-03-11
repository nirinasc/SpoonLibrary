module API::V1
  # V1 API Users Resources
  class UsersController < API::V1::ApplicationController
    # GET /users/me
    # Return the current user info
    def me
      render json: current_user, status: :ok
    end
  end
end
