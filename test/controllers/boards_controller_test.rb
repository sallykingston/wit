require 'test_helper'

class BoardsControllerTest < ActionController::TestCase
  def setup
    @board = boards(:one)
    @user = users(:one)
    @attributes = Board.attribute_names
    session[:user_id] = @user.id
  end

  def teardown
    session[:user_id] = nil
  end

  class BoardsFormatHTML < BoardsControllerTest
    test "GET #index" do
      get :index, format: :html
      assert assigns(:boards).include?(@board)
      assert_response 200
    end

    test "GET #show" do
      get :show, format: :html, id: @board
      assert_equal @board, assigns(:board)
      assert_response :success
    end
  end

  class BoardsFormatJSON < BoardsControllerTest
    test "GET #index json" do
      get :index, format: :json
      response_item = JSON.parse(response.body)[0]
      @attributes.each do |attr|
        assert_equal Board.last.send(attr), response_item[attr]
      end
      assert_response :success
    end

    test "GET #show" do
      get :show, format: :json, id: @board
      response_item = JSON.parse(response.body)
      @attributes.each do |attr|
        assert_equal Board.last.send(attr), response_item[attr]
      end
      assert_response :success
    end
  end
end
