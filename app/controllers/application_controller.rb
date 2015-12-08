class ApplicationController < ActionController::Base
  include AuthUserLevel

  protect_from_forgery with: :null_session

  helper_method :current_user
  helper_method :current_admin_user
  helper_method :non_member

end
