require "test_helper"

class FriendTest < ActiveSupport::TestCase
  def setup
    @user = users(:hyeyoo)
    @follow = users(:member)
  end

  test 'friend validate' do
    @friendship = Friend.create(user_id: @user.id, follow_id: @follow.id)
    assert @friendship.valid?

    # duplicated
    @duplicated_follow = Friend.create(user_id: @user.id, follow_id: @follow.id)
    assert_not @duplicated_follow.valid?

    # self-follow
    @self_follow = Friend.create(user_id: @user.id, follow_id: @user.id)
    assert_not @self_follow.valid?
  end

  test 'friend association' do
    # check fixture association (hyekim, dummy)
    @user.followings.each do |followee|
      assert Friend.where(user_id: @user.id, follow_id: followee.id).exists?
    end

    # check association change
    assert_difference '@user.followings.count', 1 do
      Friend.create(user_id: @user.id, follow_id: @follow.id)
    end
  end
end
