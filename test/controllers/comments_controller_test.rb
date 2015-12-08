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

  test "PATCH #update succeeds with valid attributes" do
    old_content = @comment.content
    new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
    patch :update,  format: :html,
                    topic_id: @topic.id,
                    id: @comment.id,
                    comment: { content: new_content }
    @comment.reload
    assert @comment.content == new_content
    assert_equal @comment.user.id, session[:user_id], "Comment user should be the current session user"
    assert_redirected_to topic_path(@topic), "Comment update should redirect to parent topic show"
  end

  test "PATCH #update fails with invalid attributes" do
    old_content = @comment.content
    patch :update,  format: :html,
                    topic_id: @topic.id,
                    id: @comment.id,
                    comment: { content: nil }
    @comment.reload
    assert @comment.content == old_content
    assert_equal @comment.user.id, session[:user_id], "Comment user should be the current session user"
    assert_redirected_to topic_path(@topic), "Comment update should redirect to parent topic show"
  end

  test "PATCH #update fails with valid attributes when comment user is not session user" do
    @diff_user = users(:two)
    session[:user_id] = @diff_user.id
    old_content = @comment.content
    new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
    patch :update,  format: :html,
                    topic_id: @topic.id,
                    id: @comment.id,
                    comment: { content: new_content }
    @comment.reload
    assert @comment.content == old_content
    refute @comment.user.id == session[:user_id], "Current session user should not be comment author"
    assert_match /You didn't post this reply! Only the author can make changes./, flash[:notice], "Failed comment update should trigger flash alert"
    assert_redirected_to topic_path(@topic), "Failed comment update by user other than author should redirect to parent topic show"
  end

  test "DELETE #destroy" do
    assert_difference('Comment.count', -1) do
      delete :destroy, format: :html, topic_id: @topic.id, id: @comment.id
    end
    assert_redirected_to topic_path(@topic)
  end
end
