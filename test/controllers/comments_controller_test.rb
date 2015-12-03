require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    session[:user_id] = @user.id
    @attributes = Comment.attribute_names
    @comment = comments(:topic_comment)
    @comment.update_attributes(user_id: @user.id)
    @topic = topics(:one)
  end

  def teardown
    session[:user_id] = nil
  end

  test "POST #create succeeds with valid attributes" do
    test_content = "testing content in some comment creation"
    assert_difference('Comment.count', 1) do
      post :create, format: :html,
                    topic_id: @topic.id,
                    comment: {  commentable_type: Topic,
                                commentable_id: @topic.id,
                                content: test_content
                    }
    end
    assert @topic.comments.last.content == test_content, "Last comment object should match comment just created"
    assert_redirected_to topic_path(@topic), "Comment creation should redirect to parent topic show"
  end

  test "POST #create fails with invalid attributes" do
    test_content = "testing content in some comment creation"
    assert_no_difference('Comment.count') do
      post :create, format: :html,
                    topic_id: @topic.id,
                    comment: {  commentable_type: Topic,
                                commentable_id: @topic.id,
                                content: nil
                    }
    end
    assert @topic.comments.last.content == @comment.content, "Last comment object for parent topic should match fixture comment"
    assert_match /Something about your reply is off.... /, flash[:error], "Failed comment create should trigger flash error"
    assert_redirected_to topic_path(@topic), "Failed comment create should redirect to parent topic show"
  end
end
