class Auth::NotificationsController < ApplicationController
    layout 'auth'

    def success_signup

        if flash[:notice].nil? || flash[:notice] != t('devise.registrations.signed_up_but_inactive')
            redirect_to root_path
        end
    
    end

end