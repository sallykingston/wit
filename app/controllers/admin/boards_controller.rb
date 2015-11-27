module Admin
  class BoardsController < Admin::ApplicationController
    def index
      super
    end

    def new
      super
    end

    def create
      @board = Board.new(board_params)
      respond_to do |format|
        if @board.save
          format.html { redirect_to admin_board_path(@board) }
          format.json { render json: @board }
        else
          format.html {
            flash[:alert] = "NOPE! Something is not quite right..."
            redirect_to new_admin_board_path
          }
          format.json { render json: @board.errors, status: :unprocessable_entity }
        end
      end
    end

    def show
      super
    end

    def edit
      super
    end

    def update
      @board = get_board
      respond_to do |format|
        if @board.update_attributes(board_params)
          format.html { redirect_to admin_board_path(@board) }
          format.json { render json: @board, status: 202 }
        else
          format.html {
            flash[:alert] = "NOPE! Something is not quite right..."
            redirect_to edit_admin_board_path(@board)
          }
          format.json { render json: @board.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @board = get_board
      @board.destroy
      respond_to do |format|
        format.html { redirect_to admin_boards_path }
        format.json { head :no_content }
      end
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   User.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    private

    def get_board
      Board.find(params[:id])
    end

    def board_params
      params.require(:board).permit(:title, :description)
    end
  end
end
