require "test_helper"
require "json"

module Api
  class TournamentParticipantsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @current_user = users(:hyekim)
      sign_in @current_user
    end

    test "create" do
      tournament = tournaments :tournament1
      before_conut = tournament.participants.count
      post api_tournament_tournament_participants_path(tournament.id), as: :json
      assert_response :created
      after_count = tournament.participants.count
      assert_equal before_conut + 1, after_count
    end
  end
end
