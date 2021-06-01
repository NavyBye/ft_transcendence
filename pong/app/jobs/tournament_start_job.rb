class TournamentStartJob < ApplicationJob
  queue_as :default

  def perform(tournament_id)
    Tournament.find(tournament_id).start
  end
end
