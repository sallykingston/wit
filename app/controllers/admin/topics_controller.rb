module Admin
  class TopicsController < Admin::ApplicationController
    def index
      super
    end

    def new
      super
    end

    def create
      super
    end

    def show
      super
    end

    def edit
      super
    end

    def update
      super
    end

    def destroy
      @topic = get_topic
      @topic.destroy
      respond_to do |format|
        format.html { redirect_to admin_topics_path }
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

    # def get_board
    #   Board.find(params[:forum_id])
    # end

    def get_topic
      Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:title, :content, :user_id, :board_id)
    end
  end
end
