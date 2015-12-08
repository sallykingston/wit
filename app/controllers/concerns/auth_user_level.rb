module AuthUserLevel
  extend ActiveSupport::Concern

  def authenticate_wit_membership!
    unless current_user.wit_member
      flash[:notice] = "This area is restricted to members of CHS Women in Tech only."
      redirect_to root_path
    end
  end

  def authenticate_admin!
    unless current_admin_user
      flash[:notice] = "This area is restricted to administrators only."
      redirect_to root_path
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin_user
    @current_admin_user = current_user.try(:admin)
  end

  def non_member
    !current_user.try(:wit_member)
  end
end
