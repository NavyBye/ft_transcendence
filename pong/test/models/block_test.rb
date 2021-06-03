require "test_helper"

class BlockTest < ActiveSupport::TestCase
  def setup
    @user = users(:hyeyoo)
    @blocked = users(:hyekim)
  end

  test 'double block' do
    assert_difference '@user.reload.blacklist.count', 1 do
      @block = Block.create(user_id: @user.id, blocked_user_id: @blocked.id)
    end
    assert @block.valid?

    assert_no_difference '@user.reload.blacklist.count', 1 do
      @block = Block.create(user_id: @user.id, blocked_user_id: @blocked.id)
    end
    assert_not @block.valid?
  end

  test 'self block' do
    assert_no_difference '@user.reload.blacklist.count', 1 do
      @block = Block.create(user_id: @user.id, blocked_user_id: @user.id)
    end
    assert_not @block.valid?
  end
end
