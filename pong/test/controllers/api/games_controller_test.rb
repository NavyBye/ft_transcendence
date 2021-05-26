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
  end
end
