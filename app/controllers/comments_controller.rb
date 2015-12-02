class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @item = commented_item
    @comment.commentable_type = @item.class
    @comment.commentable_id = @item.id
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.html {
          redirect_to commented_item_url(@item)
          flash[:success] = "Comment successfully posted!"
        }
        # format.json { render json: Topic.find(@comment.commentable_id) }
      else
        format.html {
          flash[:error] = "Something about your reply is off.... #{@comment.errors.messages}"
          redirect_to commented_item_url(@item)
        }
        # format.json { render json: Topic.find(@comment.commentable_id).errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type, :user_id)
  end

  def commented_item
    if params[:topic_id]
      # id = params[:topic_id]
      Topic.find(params[:topic_id])
    else
      # id = params[:article_id]
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
