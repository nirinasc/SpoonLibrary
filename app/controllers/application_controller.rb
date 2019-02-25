class ApplicationController < ActionController::Base
    layout :set_layout

    def authenticate_admin_user!
        redirect_to new_user_session_path unless current_user && current_user.admin?
    end

    def after_sign_in_path_for(resource)
        resource.admin? ? admin_root_path : store_index_path
    end

    private

    def set_layout
        devise_controller? ? 'auth' : 'store'
    end
end
