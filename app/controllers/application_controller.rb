# @author nirina
# Front Controller Parent
class ApplicationController < ActionController::Base
  layout :set_layout

  # Active admin user authorization check
  # redirect to login path if the current user is not an admin
  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user&.admin?
  end

  # define the path to redirect after success sign in
  # @param resource [User] the signed user
  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : store_index_path
  end

  # redirect unauthorized user to store
  # @param exception [Exception] the unauthorized Exception
  def access_denied(exception)
    redirect_to store_index_path, alert: exception.message
  end

  private

  # set custom layout for store and authentications pages
  def set_layout
    devise_controller? ? 'auth' : 'store'
  end

  # set the current user to User model
  def set_current_user
    User.current = current_user
  end
end
