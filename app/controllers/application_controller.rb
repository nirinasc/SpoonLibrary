class ApplicationController < ActionController::Base
    def authenticate_admin_user!
        redirect_to new_user_session_path unless current_user && current_user.admin?
    end
end
