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
  end
end
