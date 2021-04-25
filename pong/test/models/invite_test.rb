require "test_helper"

class InviteTest < ActiveSupport::TestCase
  def setup
    @invite_one = invites(:testguild_to_hyekim)
    @invite_two = invites(:test2_to_hyekim)
  end

  test "duplicated invite" do
    testguild = @invite_one.guild
    hyekim = @invite_one.user
    new_invite = Invite.new(guild_id: testguild.id, user_id: hyekim.id)
    assert_not new_invite.valid?
  end

  # TODO : invite to someone who already have guild

end
