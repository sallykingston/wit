require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  def setup
    @board = boards(:one)
  end

  test 'the fixture is valid' do
    assert @board.valid?, @board.errors.messages
  end

  test 'board is invalid without a title' do
    @board.title = nil
    refute @board.valid?, 'Board must have a title'
  end

  test 'board is invalid without a description' do
    @board.description = nil
    refute @board.valid?, 'Board must have a description'
  end
end
