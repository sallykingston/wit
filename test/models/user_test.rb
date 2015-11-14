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
    refute @nonAdmin.valid?
  end

  test 'user is invalid without uid' do
    @nonAdmin.uid = nil
    refute @nonAdmin.valid?
  end

  test 'user is invalid without name' do
    @nonAdmin.name = nil
    refute @nonAdmin.valid?
  end

  test 'user is valid without photo' do
    @nonAdmin.photo = nil
    assert @nonAdmin.valid?
  end
end
