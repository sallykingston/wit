require 'test_helper'

class AdminBoardsControllerTest < ActionController::TestCase
  def setup
    @controller = Admin::BoardsController.new
    @admin = users(:two)
    @board = boards(:one)
    @attributes = Board.attribute_names
    session[:user_id] = @admin.id
  end

  def teardown
    session[:user_id] = nil
  end

  class BoardsFormatHTML < AdminBoardsControllerTest
    test "POST #create succeeds with valid attributes" do
      assert_difference('Board.count', 1) do
        post :create, format: :html,
                      board: {  title: 'FakeTitle',
                                description: "Fake /n Description /n Dawg"
                               }
      end
      assert Board.last.description == "Fake /n Description /n Dawg", 'Last board object should match board just created'
      assert_redirected_to admin_board_path(assigns(:board)), 'Board creation should redirect to admin board show'
    end

    test "POST #create fails and redirects with invalid attributes" do
      assert_no_difference('Board.count') do
        post :create, format: :html,
                      board: {  title: nil,
                                description: "Fake /n Description /n Dawg"
                               }
      end
      assert Board.last.description == @board.description, 'Last board object should match fixture board'
      assert_equal flash[:alert], "NOPE! Something is not quite right...", 'Failed board create should trigger flash alert'
      assert_redirected_to new_admin_board_path, 'Failed board create should re-render new board form'
    end

    test "PATCH #update succeeds with valid attributes" do
      old_title = @board.title
      old_description = @board.description
      new_title = "Bippity Boppity Boop"
      new_description = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :html,
                      id: @board,
                      board: {  title: new_title,
                                description: new_description
                               }
      @board.reload
      assert @board.title == new_title
      assert @board.description == new_description
      assert_redirected_to admin_board_path(@board), 'Board update should redirect to admin board show'
    end

    test "PATCH #update fails and redirects with invalid attributes" do
      old_title = @board.title
      old_description = @board.description
      new_title = nil
      new_description = "this is valid new description... too bad the title is not"
      patch :update,  format: :html,
                      id: @board,
                      board: {  title: new_title,
                                description: new_description
                               }
      @board.reload
      assert @board.title == old_title
      assert @board.description == old_description
      assert_equal flash[:alert], "NOPE! Something is not quite right...", 'Failed board update should trigger flash alert'
      assert_redirected_to edit_admin_board_path(@board), 'Failed board update should re-render edit board form'
    end

    test "DELETE #destroy" do
      assert_difference('Board.count', -1) do
        delete :destroy, format: :html, id: @board
      end
      assert_redirected_to admin_boards_path, 'Board deletion should redirect to admin board index'
    end
  end

  class BoardsFormatJSON < AdminBoardsControllerTest
    test "POST #create succeeds with valid attributes" do
      assert_difference('Board.count', 1) do
        post :create, format: :json,
                      board: {  title: 'I am an board!',
                                description: '.ajsdnlajsndakjsndasjdnajs asdjkaslkdjaskdjas asjfalksjdlaskdmalskdm'
                               }
      end
      assert_response 200, 'Board creation should return successful response code'
    end

    test "POST #create fails with invalid attributes" do
      assert_no_difference('Board.count') do
        post :create, format: :json,
                      board: {  title: nil,
                                description: 'asdjkasdljasldjasld aksldjasdj kalsjd;akjsd'
                               }
      end
      assert_response 422, 'Failed board creation should return unprocessable entity'
    end

    test "PATCH #update succeeds with valid attributes" do
      old_title = @board.title
      old_description = @board.description
      new_title = "Bippity Boppity Boop"
      new_description = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :json,
                      id: @board,
                      board: {  title: new_title,
                                description: new_description
                               }
      @board.reload
      assert @board.title == new_title, 'Board title should have been updated'
      assert @board.description == new_description, 'Board description should have been updated'
      assert_response :success, 'Board update should return successful response code'
    end

    test "PATCH #update fails with invalid attributes" do
      old_title = @board.title
      old_description = @board.description
      new_title = nil
      new_description = "some valid description"
      patch :update,  format: :json,
                      id: @board,
                      board: {  title: new_title,
                                description: new_description
                               }
      @board.reload
      assert @board.title == old_title
      assert @board.description == old_description
      assert_response 422, 'Failed board update should return unprocessable entity'
    end

    test "DELETE #destroy" do
      assert_difference('Board.count', -1) do
        delete :destroy, format: :json, id: @board
      end
      assert_response :success, 'Board deletion should return successful response code'
    end
  end
end
