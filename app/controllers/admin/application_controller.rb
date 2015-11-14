# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
class Admin::ApplicationController < Administrate::ApplicationController
  before_filter :authenticate_admin

  def authenticate_admin
    unless current_user.admin
      flash[:alert] = "This area is restricted to administrators only."
      redirect_to root_path
    end
  end

  # Override this value to specify the number of elements to display at a time
  # on index pages. Defaults to 20.
  # def records_per_page
  #   params[:per_page] || 20
  # end


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
