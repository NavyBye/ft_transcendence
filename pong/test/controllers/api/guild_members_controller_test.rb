require "test_helper"
require "json"

module Api
  class GuildMembersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
      @guild = guilds(:test)
    end

    test "guild member lists" do
      login :member
      get "/api/guilds/#{@guild.id}/members"
      assert_response :success
      result.each do |members|
        assert @user.guild.guild_member_relationship.where(id: members['id']).exists?
      end
    end

    test "guild member update successfully" do
      login :master
      member = users(:member)
      put "/api/guilds/#{@guild.id}/members/#{member.id}", params: { role: 'officer' }
      assert_response :success
      assert_equal result['role'], 'officer'
    end

    test "guild member update successfully with admin" do
      login :admin
      member = users(:member)
      put "/api/guilds/#{@guild.id}/members/#{member.id}", params: { role: 'officer' }
      assert_response :success
      assert_equal result['role'], 'officer'
    end

    test "guild member update successfully with owner" do
      login :owner
      member = users(:member)
      put "/api/guilds/#{@guild.id}/members/#{member.id}", params: { role: 'officer' }
      assert_response :success
      assert_equal result['role'], 'officer'
    end

    test "guild member update with member" do
      login :member
      officer = users(:officer)
      put "/api/guilds/#{@guild.id}/members/#{officer.id}", params: { role: 'member' }
      assert_response :forbidden
    end

    test "guild member master update SUCCESS" do
      login :master
      member = users(:member)
      member_gm = GuildMember.find_by(guild_id: @guild.id, user_id: member.id)
      put "/api/guilds/#{@guild.id}/members/#{member.id}", params: { role: 'master' }
      assert_response :ok
      assert_equal member_gm.reload.role, 'master'
    end

    test "guild member master update SUCCESS, by owner" do
      login :owner
      member = users(:member)
      member_gm = GuildMember.find_by(guild_id: @guild.id, user_id: member.id)
      put "/api/guilds/#{@guild.id}/members/#{member.id}", params: { role: 'master' }
      assert_response :ok
      assert_equal member_gm.reload.role, 'master'
    end

    test "guild master master update SUCCESS, by owner" do
      login :owner
      master = users(:master)
      master_gm = GuildMember.find_by(guild_id: @guild.id, user_id: master.id)
      put "/api/guilds/#{@guild.id}/members/#{master.id}", params: { role: 'master' }
      assert_response :ok
      assert_equal master_gm.reload.role, 'master'
    end

    # destroy
    test "guild normal member self destroy" do
      login :member
      assert_difference '@guild.members.count', -1 do
        delete "/api/guilds/#{@guild.id}/members/#{@user.id}"
      end
      assert_response :success
    end

    test "guild normal member destroy by master" do
      login :master
      member = users(:member)
      assert_difference '@guild.members.count', -1 do
        delete "/api/guilds/#{@guild.id}/members/#{member.id}"
      end
      assert_response :success
    end

    test "guild normal member destroy by owner" do
      login :owner
      member = users(:member)
      assert_difference '@guild.members.count', -1 do
        delete "/api/guilds/#{@guild.id}/members/#{member.id}"
      end
      assert_response :success
    end

    test "guild normal member destroy by admin" do
      login :admin
      member = users(:member)
      assert_difference '@guild.members.count', -1 do
        delete "/api/guilds/#{@guild.id}/members/#{member.id}"
      end
      assert_response :success
    end

    test "guild master member destroy" do
      login :master
      assert_difference 'Guild.count', -1 do
        delete "/api/guilds/#{@guild.id}/members/#{@user.id}"
      end
      assert_response :success
    end

    test "destroy fail" do
      hyeyoo = users(:hyeyoo)
      testguild = guilds(:one)
      login :master
      delete "/api/guilds/#{testguild.id}/members/#{hyeyoo.id}"
      assert_response :forbidden
    end

    private

    def login(user_fixture_symbol)
      @user = users(user_fixture_symbol)
      sign_in @user
    end

    def result
      @result = JSON.parse @response.body
    end
  end
end
