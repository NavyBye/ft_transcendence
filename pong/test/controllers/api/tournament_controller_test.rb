require "test_helper"
require "json"

module Api
  class TournamentControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      sign_in users(:hyekim)
    end

    test "index" do
      get api_tournaments_path, as: :json
      assert_response :ok
    end

    test "create" do
      post api_tournaments_path, as: :json,
                                 params: { title: "RUBY", is_ladder: false, addon: false,
                                           max_participants: 8, start_at: (Time.zone.now + 3.hours) }
      assert_response :forbidden
      sign_in users(:owner)

      post api_tournaments_path, as: :json
      assert_response :bad_request
      tournament = tournaments :tournament1
      tournament.destroy!

      post api_tournaments_path, as: :json,
                                 params: { title: "RUBY", is_ladder: false, addon: false,
                                           max_participants: 8, start_at: (Time.zone.now + 3.hours) }
      assert_response :created
    end
  end
end
