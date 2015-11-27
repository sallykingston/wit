require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @nonAdmin = users(:one)
    @admin = users(:two)
  end

  test 'the fixtures are valid' do
    assert @nonAdmin.valid?, {"non_admin_user": @nonAdmin.errors.messages}
    assert @admin.valid?, {"admin_user": @admin.errors.messages}
  end

  test 'user is invalid without provider' do
    @nonAdmin.provider = nil
    refute @nonAdmin.valid?, "User provider cannot be nil"
  end

  test 'user is invalid without uid' do
    @nonAdmin.uid = nil
    refute @nonAdmin.valid?, "User UID cannot be nil"
  end

  test 'user is invalid without name' do
    @nonAdmin.name = nil
    refute @nonAdmin.valid?, "User name cannot be nil"
  end

  test 'user is valid without photo' do
    @nonAdmin.photo = nil
    assert @nonAdmin.valid?, "User photo can be nil"
  end

  test 'user is invalid with nil admin status' do
    @admin.admin = nil
    refute @admin.valid?, "User admin status cannot be nil"
  end

  test 'user responds to topics call' do
    @topic = topics(:one)
    @topic.update_attributes(user_id: @nonAdmin.id)
    assert_respond_to @nonAdmin, :topics, 'User should respond to topics call'
    assert @nonAdmin.topics.include?(@topic), 'User topics collection should include topic fixture'
  end

  test 'user responds to articles call' do
    @article = articles(:one)
    @article.update_attributes(user_id: @admin.id)
    assert_respond_to @admin, :articles, 'User should respond to articles call'
    assert @admin.articles.include?(@article), 'User articles collection should include article fixture'
  end

  test 'user responds to comments call' do
    @comment = comments(:article_comment)
    @comment.update_attributes(user_id: @nonAdmin.id)
    assert_respond_to @nonAdmin, :comments, 'User should respond to comments call'
    assert @nonAdmin.comments.include?(@comment), 'User comments collection should include comment fixture'
  end
end
