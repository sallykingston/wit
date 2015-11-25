class ArticlesController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show]

  def index
    @articles = Article.all
    respond_to do |format|
      format.html
      format.json { render json: @articles }
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    respond_to do |format|
      if @article.save
        format.html { redirect_to article_path(@article) }
        format.json { render json: @article }
      else
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @article = get_article
    respond_to do |format|
      format.html
      format.json { render json: @article }
    end
  end

  def edit
    @article = get_article
  end

  def update
    @article = get_article
    respond_to do |format|
      if @article.user == current_user
        if @article.update_attributes(article_params)
          format.html { redirect_to article_path(@article) }
          format.json { render json: @article, status: 202 }
        else
          format.html { render :edit }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @article }
        format.json { render json: {}, status: 401 }
      end
    end
  end

  def destroy
    @article = get_article
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_path }
      format.json { head :no_content }
    end
  end

  private

  def get_article
    Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :user_id)
  end
end
