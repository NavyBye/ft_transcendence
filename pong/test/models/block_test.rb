require "test_helper"

class BlockTest < ActiveSupport::TestCase
  def setup
    @user = users(:hyeyoo)
    @blocked = users(:hyekim)
  end

  test 'double block' do
    @block = Block.create(user_id: @user.id, blocked_user_id: @blocked.id)
    assert @block.valid?

    @block = Block.create(user_id: @user.id, blocked_user_id: @blocked.id)
    assert_not @block.valid?
  end

  test 'self block' do
    @block = Block.create(user_id: @user.id, blocked_user_id: @user.id)
    assert_not @block.valid?
  end
end
