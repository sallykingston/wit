class TopicsController < ApplicationController
  # before_action :authenticate_wit_membership!

  def index
    @board = get_board
    @topics = @board.topics
    respond_to do |format|
      format.html
      format.json { render json: @topics }
    end
  end

  def new
    @board = get_board
    @topic = @board.topics.new
  end

  def create
    @board = get_board
    @topic = @board.topics.new(topic_params)
    @topic.user_id = current_user.id
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic }
        format.json { render json: @topic }
      else
        format.html {
          flash[:alert] = "Something about this post is off.... #{@topic.errors.messages}"
          render :new
        }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @topic = get_topic
    respond_to do |format|
      format.html
      format.json { render json: @topic }
    end
  end

  def edit
    @topic = get_topic
    if @topic.user != current_user
      redirect_to @topic
    end
  end

  def update
    @topic = get_topic
    respond_to do |format|
      if @topic.user == current_user
        if @topic.update_attributes(topic_params)
          format.html { redirect_to @topic }
          format.json { render json: @topic, status: 202 }
        else
          format.html {
            flash[:alert] = "Something about this post is off.... #{@topic.errors.messages}"
            render :edit
          }
          format.json { render json: @topic.errors, status: :unprocessable_entity }
        end
      else
        format.html {
          flash[:notice] = "You didn't post this topic! Only the author can make changes."
          redirect_to @topic
        }
        format.json { render json: {}, status: 401 }
      end
    end
  end

  def destroy
    @topic = get_topic
    @board = @topic.board
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to forum_topics_path(@board) }
      format.json { head :no_content }
    end
  end

  private

  def get_board
    Board.find(params[:forum_id])
  end

  # def get_topic_board
  #   board = get_board
  #   board.topics.find(params[:id])
  # end

  def get_topic
    Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :content, :user_id, :board_id)
  end
end
