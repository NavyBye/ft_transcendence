class TournamentStartJob < ApplicationJob
  queue_as :default

  def perform(tournament_id)
    tournament = Tournament.find_by id: tournament_id
    tournament&.start
  end
end
