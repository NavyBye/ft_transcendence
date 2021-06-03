module Api
  class TournamentsController < ApplicationController
    before_action :authenticate_user!

    def index
      tournament = Tournament.first
      if tournament.nil?
        render json: {}, status: :ok
      else
        render json: serialize(tournament), status: :ok
      end
    end

    def create
      raise Tournament::PermissionDenied if current_user.user?

      tournament = Tournament.create! tournament_params
      render json: serialize(tournament), status: :created
    end

    private

    def serialize(tournament)
      data = tournament.as_json
      data["participants_count"] = tournament.participants.count
      data
    end

    def tournament_params
      params.permit :title, :max_participants, :is_ladder, :addon, :start_at
    end
  end
end
