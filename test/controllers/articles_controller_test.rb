require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    @article = articles(:one)
    @article.update_attributes(user_id: @user.id)
    @attributes = ["id", "user_id", "title", "content", "type"]
    @comment = comments(:article_comment)
    @comment.update_attributes(user_id: @user.id)
    sign_in(@user)
  end

  def teardown
    sign_out
  end

  class ArticlesWhenNoCurrentUser < ArticlesControllerTest
    def setup
      super
      sign_out
    end

    test "GET #index when no user signed in" do
      get :index, format: :html
      assert_template :index
    end

    test "GET #show when no user signed in" do
      get :show, format: :html, id: @article
      assert_template :show
    end
  end

  class ArticlesFormatHTML < ArticlesControllerTest
    test "GET #index" do
      get :index, format: :html
      assert assigns(:articles).include?(@article)
      assert_template :index
    end

    test "GET #show" do
      get :show, format: :html, id: @article
      assert_equal @article, assigns(:article)
      assert_template :show
    end
  end

  # class ArticlesFormatJSON < ArticlesControllerTest
  #   test "GET #index json" do
  #     get :index, format: :json
  #     response_item = JSON.parse(response.body)[1]
  #     expected_item = Article.find(response_item["id"])
  #     @attributes.each do |attr|
  #       assert_equal expected_item.send(attr), response_item[attr], "#{attr} not as expected"
  #     end
  #     assert_response :success
  #   end
  #
  #   test "GET #show" do
  #     get :show, format: :json, id: @article
  #     response_item = JSON.parse(response.body)
  #     @attributes.each do |attr|
  #       assert_equal Article.last.send(attr), response_item[attr], "#{attr} not as expected"
  #     end
  #     assert_response :success
  #   end
  # end
end
