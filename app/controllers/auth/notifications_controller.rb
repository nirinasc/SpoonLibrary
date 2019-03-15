# @auth nirina
# Auth::NotificationsController Class
class Auth::NotificationsController < ApplicationController
  layout 'auth'

  # show success signup message
  # Redirect to root path if accessed directly
  def success_signup
    redirect_to root_path if flash[:notice].nil? || flash[:notice] != t('devise.registrations.signed_up_but_inactive')
  end
end
