require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  def setup
    @board = boards(:one)
    @topic = topics(:one)
    @user = users(:one)
    @attributes = Topic.attribute_names
    @topic.update_attributes(board_id: @board.id, user_id: @user.id)
    @comment = comments(:topic_comment)
    @comment.update_attributes(user_id: @user.id)
    sign_in(@user)
  end

  def teardown
    sign_out
  end

  class TopicsWhenNoCurrentUser < TopicsControllerTest
    def setup
      super
      session[:user_id] = nil
    end

    test "GET #index when no user signed in" do
      session[:user_id] = nil
      get :index, format: :html, forum_id: @board.id
      assert_redirected_to root_path
    end

    test "GET #show when no user signed in" do
      session[:user_id] = nil
      get :show, format: :html, forum_id: @board.id, id: @topic
      assert_redirected_to root_path
    end
  end

  class TopicsFormatHTML < TopicsControllerTest
    test "GET #index" do
      get :index, format: :html, forum_id: @board.id
      assert assigns(:topics).include?(@topic)
      assert_template :index
    end

    test "GET #new" do
      get :new, format: :html, forum_id: @board.id
      assert_instance_of Topic, assigns(:topic)
      assert_template :new
    end

    test "POST #create succeeds with valid attributes" do
      test_title = "testing title in some topic creation"
      test_content = "testing content in some topic creation"
      assert_difference('Topic.count', 1) do
        post :create, format: :html,
                      forum_id: @board.id,
                      topic: { title: test_title, content: test_content }
      end
      assert Topic.last.content == test_content, "Last topic object should match topic just created"
      assert_redirected_to topic_path(assigns(:topic)), "Topic creation should redirect to topic show"
    end

    test "POST #create fails with invalid attributes" do
      test_content = "testing content in some topic creation"
      assert_no_difference('Topic.count') do
        post :create, format: :html,
                      forum_id: @board.id,
                      topic: { title: nil, content: test_content }
      end
      assert Topic.last.content == @topic.content, "Last topic object should match fixture topic"
      assert_match /Something about this post is off.... /, flash[:alert], "Failed topic create should trigger flash alert"
      assert_template :new, "Failed topic create should re-render new topic form"
    end

    test "GET #show" do
      get :show, format: :html, id: @topic
      assert_equal @topic, assigns(:topic)
      assert_template :show
    end

    test "GET #edit renders if created by current user" do
      get :edit, format: :html, id: @topic
      assert_equal @user, @topic.user
      assert_template :edit
    end

    test "GET #edit redirects if not created by current user" do
      @diff_user = users(:two)
      session[:user_id] = @diff_user.id
      get :edit, format: :html, id: @topic
      refute @diff_user == @topic.user
      assert_redirected_to topic_path(@topic)
    end

    test "PATCH #update succeeds with valid attributes" do
      old_title = @topic.title
      old_content = @topic.content
      new_title = "Bippity Boppity Boop"
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :html,
                      id: @topic,
                      topic: { title: new_title, content: new_content }
      @topic.reload
      assert @topic.title == new_title
      assert @topic.content == new_content
      assert_equal @topic.user.id, session[:user_id], "Topic user should be the current session user"
      assert_redirected_to topic_path(@topic), "Topic update should redirect to topic show"
    end

    test "PATCH #update fails with invalid attributes" do
      old_title = @topic.title
      old_content = @topic.content
      new_title = nil
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :html,
                      id: @topic,
                      topic: { title: new_title, content: new_content }
      @topic.reload
      assert @topic.title == old_title
      assert @topic.content == old_content
      assert_equal @topic.user.id, session[:user_id], "Topic user should be the current session user"
      assert_match /Something about this post is off.... /, flash[:alert], "Failed topic create should trigger flash alert"
      assert_template :edit, "Failed topic update should render topic edit"
    end

    test "PATCH #update fails with valid attributes when topic user is not session user" do
      @diff_user = users(:two)
      session[:user_id] = @diff_user.id
      old_title = @topic.title
      old_content = @topic.content
      new_title = "Bippity Boppity Boop"
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :html,
                      id: @topic,
                      topic: { title: new_title, content: new_content }
      @topic.reload
      assert @topic.title == old_title
      assert @topic.content == old_content
      refute @topic.user.id==session[:user_id], "Current session user should not be topic author"
      assert_match /You didn't post this topic! Only the author can make changes./, flash[:notice], "Failed topic update should trigger flash alert"
      assert_redirected_to topic_path(@topic), "Failed topic update by user other than author should redirect to topic show"
    end

    test "DELETE #destroy" do
      assert_difference('Topic.count', -1) do
        delete :destroy, format: :html, id: @topic
      end
      assert_redirected_to forum_topics_path(@board)
    end
  end

  class TopicsFormatJSON < TopicsControllerTest
    test "GET #index json" do
      get :index, format: :json, forum_id: @board.id
      returned = JSON.parse(response.body)[0]
      @attributes.each do |attr|
        if ["created_at", "updated_at"].include?(attr)
          expected_parsed = Time.parse(Topic.last.send(attr).to_s)
          returned_parsed = Time.parse(returned[attr])
          assert_equal expected_parsed.to_s, returned_parsed.to_s
        else
          assert_equal Topic.last.send(attr), returned[attr]
        end
      end
      assert_response :success
    end

    test "POST #create succeeds with valid attributes" do
      test_title = "testing title in some topic creation"
      test_content = "testing content in some topic creation"
      assert_difference('Topic.count', 1) do
        post :create, format: :json,
                      forum_id: @board.id,
                      topic: { title: test_title, content: test_content }
      end
      assert Topic.last.content == test_content, "Last topic object should match topic just created"
      assert_response 200, 'Topic creation should return successful response code'
    end

    test "POST #create fails with invalid attributes" do
      test_content = "testing content in some topic creation"
      assert_no_difference('Topic.count') do
        post :create, format: :json,
                      forum_id: @board.id,
                      topic: { title: nil, content: test_content }
      end
      assert Topic.last.content == @topic.content, "Last topic object should match fixture topic"
      assert_response 422, "Failed topic create should return status of unprocessable entity"
    end

    test "GET #show" do
      get :show, format: :json, id: @topic
      returned = JSON.parse(response.body)
      @attributes.each do |attr|
        if ["created_at", "updated_at"].include?(attr)
          expected_parsed = Time.parse(Topic.last.send(attr).to_s)
          returned_parsed = Time.parse(returned[attr])
          assert_equal expected_parsed.to_s, returned_parsed.to_s
        else
          assert_equal Topic.last.send(attr), returned[attr]
        end
      end
      assert_response :success
    end

    test "PATCH #update succeeds with valid attributes" do
      old_title = @topic.title
      old_content = @topic.content
      new_title = "Bippity Boppity Boop"
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :json,
                      id: @topic,
                      topic: { title: new_title, content: new_content }
      @topic.reload
      assert @topic.title == new_title, 'Topic title should have been updated'
      assert @topic.content == new_content, 'Topic content should have been updated'
      assert_response :success, 'Topic update should return successful response code'
    end

    test "PATCH #update fails with invalid attributes" do
      old_title = @topic.title
      old_content = @topic.content
      new_title = nil
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :json,
                      id: @topic,
                      topic: { title: new_title, content: new_content }
      @topic.reload
      assert @topic.title == old_title, 'Topic title should not have been updated'
      assert @topic.content == old_content, 'Topic content should not have been updated'
      assert_response 422, 'Failed topic update should return unprocessable entity'
    end

    test "PATCH #update fails with valid attributes when topic user is not session user" do
      @diff_user = users(:two)
      session[:user_id] = @diff_user.id
      old_title = @topic.title
      old_content = @topic.content
      new_title = "Bippity Boppity Boop"
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :json,
                      id: @topic,
                      topic: { title: new_title, content: new_content }
      @topic.reload
      assert @topic.title == old_title
      assert @topic.content == old_content
      refute @topic.user.id==session[:user_id], "Current session user should not be topic author"
      assert_response :unauthorized, "Failed topic update by user other than author should return unauthorized status"
    end

    test "DELETE #destroy" do
      assert_difference('Topic.count', -1) do
        delete :destroy, format: :json, id: @topic
      end
      assert_response :success, 'Topic deletion should return successful response code'
    end
  end
end
