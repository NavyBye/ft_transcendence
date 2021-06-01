module Api
  class TournamentParticipantsController < ApplicationController
    def create
      tournament = Tournament.first

      tournament.participants << current_user
      render json: {}, status: :created
    end
  end
end
