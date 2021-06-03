require "test_helper"

class GuildMemberTest < ActiveSupport::TestCase
  def setup
    @member = guild_members(:hyeyoo_in_testguild)
    @user = users(:hyeyoo)
    @guild = guilds(:one)
  end

  test "normal_guild_member" do
    assert_equal 'hyeyoos', @member.user.name
    assert_equal 'testguild', @member.guild.name
    assert_equal 'master', @member.role
  end

  test "member role enum" do
    @member.role = 0
    assert_equal 'member', @member.role
    @member.role = 1
    assert_equal 'officer', @member.role
    @member.role = 2
    assert_equal 'master', @member.role
  end

  test "role range validations" do
    assert_raises ArgumentError do
      @member.role = 3
    end
    assert_raises ArgumentError do
      @member.role = -1
    end
  end

  test "one can have one guild" do
    user = users(:hyeyoo)
    other_guild = guilds(:two)
    invalid_member = GuildMember.create(user_id: user.id, guild_id: other_guild.id)
    assert_not invalid_member.valid?
  end

  # associations test
  test "associations" do
    assert_equal @guild.id, @user.guild.id

    no_guild_user = users(:hyekim)
    assert no_guild_user.guild.nil?

    assert @guild.members.where(id: @user.id).exists?
    assert_not @guild.members.where(id: no_guild_user.id).exists?
  end
end
