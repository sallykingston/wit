require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def setup
    @article = articles(:one)
    @user = users(:one)
    @attributes = Article.attribute_names
  end

  class ArticlesFormatHTML < ArticlesControllerTest
    test "GET #index" do
      get :index, format: :html
      assert assigns(:articles).include?(@article)
      assert_response 200
    end

    test "GET #show" do
      @article.update_attributes(user_id: @user.id)
      get :show, format: :html, id: @article
      assert_equal @article, assigns(:article)
      assert_response :success
    end
  end

  class ArticlesFormatJSON < ArticlesControllerTest
    test "GET #index json" do
      get :index, format: :json
      response_item = JSON.parse(response.body)[0]
      @attributes.each do |attr|
        assert_equal Article.last.send(attr), response_item[attr]
      end
      assert_response :success
    end

    test "GET #show" do
      get :show, format: :json, id: @article
      response_item = JSON.parse(response.body)
      @attributes.each do |attr|
        assert_equal Article.last.send(attr), response_item[attr]
      end
      assert_response :success
    end
  end
end
