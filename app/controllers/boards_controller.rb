class BoardsController < ApplicationController
  # before_action :authenticate_wit_membership!

  def index
    @boards = Board.all
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
