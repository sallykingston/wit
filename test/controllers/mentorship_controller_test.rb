require 'test_helper'

class MentorshipControllerTest < ActionController::TestCase
  test "GET #index" do
    get :index
    assert_template :index
  end
end
