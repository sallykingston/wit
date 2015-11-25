class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  helper_method :current_user
  helper_method :current_admin_user

  def authenticate_wit_membership!
    unless current_user.wit_member
      flash[:alert] = "This area is restricted to members of CHS Women in Tech only."
      redirect_to root_path
    end
  end

  def authenticate_admin!
    unless current_admin_user
      flash[:alert] = "This area is restricted to administrators only."
      redirect_to root_path
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin_user
    return nil if current_user && !current_user.admin
    current_user
  end
end
