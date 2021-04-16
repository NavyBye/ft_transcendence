require "test_helper"

class FriendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:hyeyoo)
    @follow = users(:hyekim)
  end
  test 'friend validate' do
    @friendship = Friend.create(user_id: @user.id, follow_id: @follow.id)
    assert @friendship.valid?

    @friendship = Friend.create(user_id: @user.id, follow_id: @follow.id)
    assert_not @friendship.valid?

    @self_follow = Friend.create(user_id: @user.id, follow_id: @user.id)
    assert_not @self_follow.valid?
  end
end
