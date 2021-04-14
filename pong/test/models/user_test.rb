require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:hyeyoo)
  end

  # nickname test
  test 'valid with nickname newcomers duplicated' do
    assert true
  end

  test 'invalid with nickname uniqueness' do
    assert true
  end

  test 'valid with nickname stripped' do
    assert true
  end

  # status test
  test 'status should greater than -1' do
    assert true
  end

  test 'status should less than 4' do
    assert true
  end

  # rank test
  test 'invalid rank pool' do
    assert true
  end
end
