module API::V1
    class UsersController < API::V1::ApplicationController
        def me  
            render json: current_user , status: :ok
        end
    end
end