require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = topics(:one)
    @user = users(:one)
    @topic.user_id = @user.id
    @board = boards(:one)
    @topic.board_id = @board.id
  end

  test 'the fixture is valid' do
    assert @topic.valid?, {"topic": @topic.errors.messages}
  end

  test 'topic is invalid without user' do
    @topic.user_id = nil
    refute @topic.valid?, "Topic user_id cannot be nil"
  end

  test 'topic responds to user call' do
    assert_respond_to @topic, :user, "Topic must respond to user call"
  end

  test 'topic is invalid without board' do
    @topic.board_id = nil
    refute @topic.valid?, "Topic board_id cannot be nil"
  end

  test 'topic responds to board call' do
    assert_respond_to @topic, :board, "Topic must respond to board call"
  end

  test 'topic is invalid without title' do
    @topic.title = nil
    refute @topic.valid?, "Topic title cannot be nil"
  end

  test 'topic is invalid without content' do
    @topic.content = nil
    refute @topic.valid?, "Topic content cannot be nil"
  end
end
