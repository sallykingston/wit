class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @item = commented_item
    @comment.assign_attributes(commentable_type: @item.class, commentable_id: @item.id, user_id: current_user.id)
    respond_to do |format|
      if @comment.save
        format.html {
          flash[:success] = "Comment successfully posted!"
          redirect_to commented_item_url(@item)
        }
      else
        format.html {
          flash[:error] = "Something about your reply is off.... #{@comment.errors.messages}"
          redirect_to commented_item_url(@item)
        }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type, :user_id)
  end

  def commented_item
    if params[:topic_id]
      Topic.find(params[:topic_id])
    else
      Article.find(params[:article_id])
    end
  end

  def commented_item_url(commented_item)
    if commented_item.class == Topic
      topic_path(commented_item)
    else
      article_path(commented_item)
    end
  end
end
