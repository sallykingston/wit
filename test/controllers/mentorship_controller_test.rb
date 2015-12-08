require 'test_helper'

class MentorshipControllerTest < ActionController::TestCase
  def setup
    @current_user = users(:one)
    sign_in(@current_user)
  end

  def teardown
    sign_out
  end

  test "GET #index" do
    get :index
    assert_template :index
  end
end
