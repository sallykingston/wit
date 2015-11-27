require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @article = articles(:one)
    @article_comment = comments(:article_comment)
    @topic = topics(:one)
    @topic_comment = comments(:topic_comment)
    @user = users(:one)
    @article_comment.update_attributes(user_id: @user.id)
  end

  test 'the fixtures are valid' do
    assert @article_comment.valid?, {"article comment": @article_comment.errors.messages}
    assert @topic_comment.valid?, {"topic comment": @topic_comment.errors.messages}
  end

  test 'comment is invalid without user' do
    @article_comment.user_id = nil
    refute @article_comment.valid?, "Comment user_id cannot be nil"
  end

  test 'comment responds to user call' do
    assert_respond_to @article_comment, :user, "Comment must respond to user call"
    assert_equal @article_comment.user, @user, "Comment user should be user fixture"
  end

  test 'comment is invalid without content' do
    @article_comment.content = nil
    refute @article_comment.valid?, "Comment content cannot be nil"
  end

  test 'comment is associated with expected article object' do
    assert_equal @article_comment.commentable_id, @article.id, "Commentable ID should match commented object id"
  end

  test 'comment is associated with expected topic object' do
    assert_equal @topic_comment.commentable_id, @topic.id, "Commentable ID should match commented object id"
  end
end
