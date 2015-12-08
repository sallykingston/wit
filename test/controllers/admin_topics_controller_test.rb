require 'test_helper'

class AdminTopicsControllerTest < ActionController::TestCase
  def setup
    @controller = Admin::TopicsController.new
    @admin = users(:two)
    @board = boards(:one)
    @topic = topics(:one)
    @attributes = Topic.attribute_names
    @topic.update_attributes(board_id: @board.id, user_id: @admin.id)
    sign_in(@admin)
  end

  def teardown
    sign_out
  end

  test "DELETE #destroy" do
    assert_difference('Topic.count', -1) do
      delete :destroy, format: :html, id: @topic
    end
    assert_redirected_to admin_topics_path
  end
end
