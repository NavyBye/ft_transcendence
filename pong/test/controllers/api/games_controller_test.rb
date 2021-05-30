require "test_helper"

module Api
  class GamesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test "create duel queue" do
      user = users(:game_test_user)
      sign_in user
      assert_changes 'GameQueue.count' do
        post api_games_url, params: { game_type: 'duel', addon: false }
      end
    end

    test "accept friendly game" do
      user = users(:game_test_user)
      sign_in user
      opposite = users(:hyekim)
      GameQueue.create(user_id: opposite.id, game_type: 'friendly', addon: false, target_id: user.id)
      # REQUESTED USER SHOULD BE 'READY' STATE
      opposite.update!(status: 'ready')
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'friendly', addon: false }
        assert_response :success
      end
      assert_equal GamePlayer.count, 2
    end

    test "accepted friendly but requester canceled" do
      user = users(:game_test_user)
      sign_in user
      assert_no_changes 'GameQueue.count' do
        post api_games_url, params: { game_type: 'friendly', addon: false }
      end
    end

    test "canceling request always success" do
      user = users(:game_test_user)
      sign_in user
      delete cancel_api_games_url
      assert_response :success
    end

    test "wait and cancel" do
      user = users(:game_test_user)
      sign_in user
      assert_difference 'GameQueue.count', 1 do
        post api_games_url, params: { game_type: 'duel', addon: false }
      end
      assert_response :success
      assert_difference 'GameQueue.count', -1 do
        delete cancel_api_games_url
      end
      assert_response :success
    end

    test "warmatch begin" do
      set_war
      user = users(:hyeyoo)
      # user.update!(status: 'online')
      sign_in user
      user.update!(status: 1)
      assert_difference 'GameQueue.count', 1 do
        post api_games_url, params: { game_type: 'war', addon: false }
        assert_response :success
      end
      # TODO : check war match
    end

    private

    def set_war
      # one(hyeyoo, dummy_member_one) vs test(master, officer, member)
      one_guild = guilds(:one)
      test_guild = guilds(:test)
      war = War.create!(war_param)
      one_wg = WarGuild.create!(war_id: war.id, guild_id: one_guild.id, war_point: 0, avoid_chance: 5)
      test_wg = WarGuild.create!(war_id: war.id, guild_id: test_guild.id, war_point: 0, avoid_chance: 5)
    end

    def war_param
      {
        end_at: Time.zone.now + 3600,
        war_time: Time.zone.now.hour,
        prize_point: 999,
        is_extended: true,
        is_addon: true
      }
    end
  end
end
