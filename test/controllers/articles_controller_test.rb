require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def setup
    @current_user = users(:two)
    @attributes = Article.attribute_names
    session[:user_id] = @current_user.id
  end

  def teardown
    session[:user_id] = nil
  end

  test "GET #index" do
    get :index, format: :json
    response_item = JSON.parse(response.body)[0]
    @attributes.each do |attr|
      assert_equal Article.last.send(attr), response_item[attr]
    end
    assert_response :success
  end

  test 'creates with valid attributes' do
    assert_difference('Article.count', 1) do
      post :create, format: :json,
                    article: { title: 'I am an article!',
                               content: '.ajsdnlajsndakjsndasjdnajs asdjkaslkdjaskdjas asjfalksjdlaskdmalskdm'
                             }
    end
    assert_response :success
  end

  test 'does not create with invalid attributes' do
    assert_no_difference('Article.count') do
      post :create, format: :json,
                    article: { title: nil,
                               content: 'asdjkasdljasldjasld aksldjasdj kalsjd;akjsd'
                             }
    end
    assert_response 422
  end

end
