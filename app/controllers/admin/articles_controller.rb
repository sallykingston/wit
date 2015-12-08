module Admin
  class ArticlesController < Admin::ApplicationController
    def index
      super
    end

    def new
      super
    end

    def create
      @article = Article.new(article_params)
      @article.user_id = @current_user.id
      respond_to do |format|
        if @article.save
          format.html { redirect_to admin_article_path(@article) }
          format.json { render json: @article }
        else
          format.html {
            flash[:alert] = "NOPE! Something is not quite right..."
            redirect_to new_admin_article_path
          }
          format.json { render json: @article.errors, status: :unprocessable_entity }
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
      @article = get_article
      respond_to do |format|
        if @article.user == @current_user
          if @article.update_attributes(article_params)
            format.html { redirect_to admin_article_path(@article) }
            format.json { render json: @article, status: 202 }
          else
            format.html {
              flash[:alert] = "NOPE! Something is not quite right..."
              redirect_to edit_admin_article_path(@article)
            }
            format.json { render json: @article.errors, status: :unprocessable_entity }
          end
        else
          format.html {
            flash[:notice] = "You didn't write this article. Only the author may edit the article."
            redirect_to admin_article_path(@article)
          }
          format.json { render json: {}, status: 401 }
        end
      end
    end

    def destroy
      @article = get_article
      @article.destroy
      respond_to do |format|
        format.html { redirect_to admin_articles_path }
        format.json { head :no_content }
      end
    end

    def records_per_page
      params[:per_page] || 10
    end

    private

    def get_article
      Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :user_id)
    end
  end
end
