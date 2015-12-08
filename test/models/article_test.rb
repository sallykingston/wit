require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = articles(:one)
    @announcement = articles(:two)
    @user = users(:one)
    @article.update_attributes(user_id: @user.id)
  end

  test 'the fixtures are valid' do
    assert @article.valid?, {"article": @article.errors.messages}
    assert @announcement.valid?, {"announcement": @announcement.errors.messages}
  end

  test 'article is invalid without user' do
    @article.user_id = nil
    refute @article.valid?, "Article user_id cannot be nil"
  end

  test 'article responds to user call' do
    assert_respond_to @article, :user, "Article must respond to user call"
    assert_equal @article.user, @user, "Article user should be user fixture"
  end

  test 'article is invalid without title' do
    @article.title = nil
    refute @article.valid?, "Article title cannot be nil"
  end

  test 'article is invalid without content' do
    @article.content = nil
    refute @article.valid?, "Article content cannot be nil"
  end

  test 'article is valid without type' do
    @article.type = nil
    assert @article.valid?, "Article type can be nil"
  end

  test 'announcement has character limit' do
    assert @announcement.char_limit, "Announcement must have character limit"
  end

end
