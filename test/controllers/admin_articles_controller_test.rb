require 'test_helper'

class AdminArticlesControllerTest < ActionController::TestCase
  def setup
    @controller = Admin::ArticlesController.new
    @current_user = users(:two)
    @article = articles(:one)
    @article.update_attributes(user_id: @current_user.id)
    @attributes = Article.attribute_names
    session[:user_id] = @current_user.id
  end

  def teardown
    session[:user_id] = nil
  end

  class ArticlesFormatHTML < AdminArticlesControllerTest
    # test "GET #index" do
    #   get :index, format: :html
    #   assert assigns(:articles).include?(@article)
    #   assert_response :success, 'Get article index should return successful response code'
    # end
    #
    # test "GET #new" do
    #   get :new, format: :html
    #   assert_instance_of Article, assigns(:article)
    #   assert_response 200, 'Get article new form should return successful response code'
    # end

    test "POST #create succeeds with valid attributes" do
      assert_difference('Article.count', 1) do
        post :create, format: :html,
                      article: { title: 'FakeTitle',
                                 content: "Fake /n Content /n Yo"
                               }
      end
      assert Article.last.content == "Fake /n Content /n Yo", 'Last article object should match article just created'
      assert_redirected_to admin_article_path(assigns(:article)), 'Article creation should redirect to admin article show'
    end

    test "POST #create fails and redirects with invalid attributes" do
      assert_no_difference('Article.count') do
        post :create, format: :html,
                      article: { title: nil,
                                 content: "Fake /n Content /n Yo"
                               }
      end
      assert Article.last.content == @article.content, 'Last article object should match fixture article'
      assert_equal flash[:alert], "NOPE! Something is not quite right...", 'Failed article create should trigger flash alert'
      assert_redirected_to new_admin_article_path, 'Failed article create should re-render new article form'
    end

    # test "GET #show" do
    #   get :show, format: :html, id: @article
    #   assert_equal @article, assigns(:article)
    #   assert_response :success, 'Get article show should return successful response code'
    # end
    #
    # test "GET #edit" do
    #   get :edit, format: :html, id: @article
    #   assert_equal @article, assigns(:article)
    #   assert_response :success, 'Get article edit form should return successful response code'
    # end
    #
    test "PATCH #update succeeds with valid attributes" do
      old_title = @article.title
      old_content = @article.content
      new_title = "Bippity Boppity Boop"
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :html,
                      id: @article,
                      article: { title: new_title,
                                 content: new_content
                               }
      @article.reload
      assert @article.title == new_title
      assert @article.content == new_content
      assert_redirected_to admin_article_path(@article), 'Article update should redirect to admin article show'
    end

    test "PATCH #update fails and redirects with invalid attributes" do
      old_title = @article.title
      old_content = @article.content
      new_title = nil
      new_content = "this is valid new content... too bad the title is not"
      patch :update,  format: :html,
                      id: @article,
                      article: { title: new_title,
                                 content: new_content
                               }
      @article.reload
      assert @article.title == old_title
      assert @article.content == old_content
      assert_equal flash[:alert], "NOPE! Something is not quite right...", 'Failed article update should trigger flash alert'
      assert_redirected_to edit_admin_article_path(@article), 'Failed article update should re-render edit article form'
    end

    test "DELETE #destroy" do
      assert_difference('Article.count', -1) do
        delete :destroy, format: :html, id: @article
      end
      assert_redirected_to admin_articles_path, 'Article deletion should redirect to admin article index'
    end
  end

  class ArticlesFormatJSON < AdminArticlesControllerTest
    # test "GET #index" do
    #   get :index, format: :json
    #   response_item = JSON.parse(response.body)[0]
    #   # returned = JSON.parse(response.body, symbolize_names: true)[0]
    #   @attributes.each do |attr|
    #     assert_equal @article.send(attr), response_item[attr]
    #   end
    #   assert_response 200, 'Get article index should return successful response code'
    # end

    test "POST #create succeeds with valid attributes" do
      assert_difference('Article.count', 1) do
        post :create, format: :json,
                      article: { title: 'I am an article!',
                                 content: '.ajsdnlajsndakjsndasjdnajs asdjkaslkdjaskdjas asjfalksjdlaskdmalskdm'
                               }
      end
      assert_response 200, 'Article creation should return successful response code'
    end

    test "POST #create fails with invalid attributes" do
      assert_no_difference('Article.count') do
        post :create, format: :json,
                      article: { title: nil,
                                 content: 'asdjkasdljasldjasld aksldjasdj kalsjd;akjsd'
                               }
      end
      assert_response 422, 'Failed article creation should return unprocessable entity'
    end

    # test "GET #show" do
    #   get :show, format: :json, id: @article
    #   response_item = JSON.parse(response.body)
    #   @attributes.each do |attr|
    #     assert_equal @article.send(attr), response_item[attr]
    #   end
    #   assert_response :success, 'Get article show should return successful response code'
    # end

    test "PATCH #update succeeds with valid attributes" do
      old_title = @article.title
      old_content = @article.content
      new_title = "Bippity Boppity Boop"
      new_content = "beep boop beep beep bop boop blip beep boop beep boop beep beep beep bop boop blip beep boop"
      patch :update,  format: :json,
                      id: @article,
                      article: { title: new_title,
                                 content: new_content
                               }
      @article.reload
      assert @article.title == new_title, 'Article title should have been updated'
      assert @article.content == new_content, 'Article content should have been updated'
      assert_response :success, 'Article update should return successful response code'
    end

    test "PATCH #update fails with invalid attributes" do
      old_title = @article.title
      old_content = @article.content
      new_title = nil
      new_content = "some valid content"
      patch :update,  format: :json,
                      id: @article,
                      article: { title: new_title,
                                 content: new_content
                               }
      @article.reload
      assert @article.title == old_title
      assert @article.content == old_content
      assert_response 422, 'Failed article update should return unprocessable entity'
    end

    test "DELETE #destroy" do
      assert_difference('Article.count', -1) do
        delete :destroy, format: :json, id: @article
      end
      assert_response :success, 'Article deletion should return successful response code'
    end
  end
end
