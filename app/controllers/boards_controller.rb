class BoardsController < ApplicationController
  def index
    @boards = Board.order('title').page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: @boards }
    end
  end

  def show
    @board = get_board
    respond_to do |format|
      format.html
      format.json { render json: @board }
    end
  end

  private

  def get_board
    Board.find(params[:id])
  end

end
