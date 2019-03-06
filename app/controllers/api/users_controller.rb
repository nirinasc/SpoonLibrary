class API::UsersController < API::ApplicationController
    def me  
        json_response(current_user)
    end
end