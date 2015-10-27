require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  def setup
    @admin = admins(:one)
  end

  test 'the fixture is valid' do
    assert @admin.valid?
  end
end
