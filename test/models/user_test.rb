require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test 'the fixture is valid' do
    assert @user.valid?
  end

  test 'user is invalid without provider' do
    @user.provider = nil
    refute @user.valid?
  end

  test 'user is invalid without uid' do
    @user.uid = nil
    refute @user.valid?
  end

  test 'user is invalid without name' do
    @user.name = nil
    refute @user.valid?
  end

  test 'user is valid without photo' do
    @user.photo = nil
    assert @user.valid?
  end
end
