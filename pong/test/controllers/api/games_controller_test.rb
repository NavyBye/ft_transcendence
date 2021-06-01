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

    test "begin duel match" do
      user = users(:game_test_user)
      sign_in user
      hyeyoo = users(:hyeyoo)
      hyeyoo.update!(status: 'ready')
      GameQueue.create!(user_id: hyeyoo.id, game_type: 'duel', addon: false)
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'duel', addon: false }
      end
    end

    test "result of ladder match" do
      user = users(:game_test_user)
      sign_in user
      hyeyoo = users(:hyeyoo)
      hyeyoo.update!(status: 'ready')
      GameQueue.create!(user_id: hyeyoo.id, game_type: 'ladder', addon: false)
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'ladder', addon: false }
      end
      assert_difference 'user.reload.rating', 42 do
        game = Game.first
        gp = GamePlayer.find_by(game_id: game.id, user_id: user.id)
        data = { 'scores' => [0, 0] }
        if gp.is_host
          data['scores'][0] = 3
        else
          data['scores'][1] = 3
        end
        GameChannel::GameResult.result_apply(game, data)
      end
    end

    test "result of ladder_tournament match" do
      user = users(:game_test_user)
      member = users(:member)
      sign_in member
      user.update!(status: 'ready')
      GameQueue.create!(user_id: user.id, game_type: 'ladder_tournament', target_id: member.id)
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'ladder_tournament', addon: false }
      end
      assert_difference 'user.reload.rank', -1 do
        game = Game.first
        gp = GamePlayer.find_by(game_id: game.id, user_id: user.id)
        data = { 'scores' => [0, 0] }
        if gp.is_host
          data['scores'][0] = 3
        else
          data['scores'][1] = 3
        end
        GameChannel::GameResult.result_apply(game, data)
      end
    end

    test "begin duel match with addon nil" do
      user = users(:game_test_user)
      sign_in user
      hyeyoo = users(:hyeyoo)
      hyeyoo.update!(status: 'ready')
      GameQueue.create!(user_id: hyeyoo.id, game_type: 'duel', addon: false)
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'duel', addon: nil }
        GameQueue.all.each do |q|
          puts "#{q.user_id} , #{q.game_type}, #{q.addon}"
        end
        assert_equal 0, GameQueue.count
      end
    end

    test "accept friendly game" do
      user = users(:game_test_user)
      sign_in user
      opposite = users(:hyekim)
      GameQueue.create(user_id: opposite.id, game_type: 'friendly', addon: false, target_id: user.id)
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

    test "warmatch queue" do
      set_war
      user = users(:hyeyoo)
      sign_in user
      user.update!(status: 'online')
      assert_difference 'GameQueue.count', 1 do
        post api_games_url, params: { game_type: 'war' }
        assert_response :success
      end
    end

    test "warmatch begin" do
      set_war
      hyeyoo = users(:hyeyoo)
      GameQueue.create!({ game_type: 'war', addon: 'false', user_id: hyeyoo.id })
      hyeyoo.update!(status: 'ready')
      member = users(:member)
      member.update!(status: 'online')
      sign_in member
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'war' }
        assert_response :success
        assert_equal true, Game.first.addon
      end
    end

    test "warmatch begin2 addon minsokim" do
      set_war
      hyeyoo = users(:hyeyoo)
      GameQueue.create!({ game_type: 'war', addon: 'true', user_id: hyeyoo.id })
      hyeyoo.update!(status: 'ready')
      member = users(:member)
      member.update!(status: 'online')
      sign_in member
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'war', addon: 'false' }
        assert_response :success
        assert_equal true, Game.first.addon
      end
    end

    test "warmatch begin addon minsokim three" do
      set_war
      War.first.update!(is_addon: false)
      hyeyoo = users(:hyeyoo)
      GameQueue.create!({ game_type: 'war', addon: 'true', user_id: hyeyoo.id })
      hyeyoo.update!(status: 'ready')
      member = users(:member)
      member.update!(status: 'online')
      sign_in member
      assert_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'war', addon: 'true' }
        assert_response :success
        assert_equal War.first.is_addon, Game.first.addon
      end
    end

    test "warmatch denied by same-guild conflict" do
      set_war
      hyeyoo = users(:hyeyoo)
      GameQueue.create!({ game_type: 'war', addon: 'false', user_id: hyeyoo.id })
      hyeyoo.update!(status: 'ready')
      member = users(:dummy_member_one)
      member.update!(status: 'online')
      sign_in member
      assert_no_difference 'Game.count', 1 do
        post api_games_url, params: { game_type: 'war', addon: false }
        assert_response :conflict
      end
    end

    private

    def set_war
      # one(hyeyoo, dummy_member_one) vs test(master, officer, member)
      one_guild = guilds(:one)
      test_guild = guilds(:test)
      war = War.create!(war_param)
      WarGuild.create!(war_id: war.id, guild_id: one_guild.id, war_point: 0, avoid_chance: 5)
      WarGuild.create!(war_id: war.id, guild_id: test_guild.id, war_point: 0, avoid_chance: 5)
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
