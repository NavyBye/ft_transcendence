class Tournament < ApplicationRecord
  has_many :tournament_participants, dependent: :destroy
  has_many :participants, through: :tournament_participants, source: :user

  after_create :start_later

  def start
    start_index = Math.sqrt(tournament_participants.count).ceil.pow(2)
    tournament_participants.shuffle.each_with_index do |participant, index|
      participant.index = start_index + index
      participant.save!
    end
    tournament_participants.each do |participant|
      participant.win while participant.index != 0 && participant.unearned_win? == true
      next if participant.index.odd? || !participant.opponent?

      participant.create_game
    end
  end

  private

  def start_later
    TournamentStartJob.set(wait_until: start_at).perform_later id
  end
end
