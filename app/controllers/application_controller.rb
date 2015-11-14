class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  helper_method :current_user
  helper_method :current_admin_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin_user
    return nil if current_user && !current_user.admin
    current_user
  end
end
