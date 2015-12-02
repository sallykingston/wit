require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    session[:user_id] = @user.id
  end

  def teardown
    session[:user_id] = nil
  end


end
