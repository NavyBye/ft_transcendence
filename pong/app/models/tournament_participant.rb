class ParticipantsCountValidator < ActiveModel::Validator
  def validate(record)
    tournament = record.tournament
    return unless !tournament.nil? && tournament.max_participants <= tournament.participants.count

    record.errors.add :base, "Too many participants"
  end
end

class TournamentParticipant < ApplicationRecord
  # associations
  belongs_to :tournament
  belongs_to :user

  # validations
  validates :user_id, uniqueness: true
  validates :index, uniqueness: { scope: :tournament_id }, allow_nil: true
  validates_with ParticipantsCountValidator, on: :create

  def unearned_win?
    return false if index <= 1

    opponent_index = (index.even? ? index + 1 : index - 1)
    check_unearned_win_recursively opponent_index
  end

  def opponent?
    return false if index <= 1

    tournament.tournament_participants.exists? index: (index.even? ? index + 1 : index - 1)
  end

  def opponent
    return nil if index <= 1

    tournament.tournament_participants.find_by index: (index.even? ? index + 1 : index - 1)
  end

  def victoryous?
    index == 1
  end

  def victory
    user.update! trophy: user.trophy + 1
    tournament.destroy!
  end

  def win
    update! index: index / 2
  end

  def create_game
    game = Game.create! game_type: :tournament, addon: tournament.addon
    GamePlayer.create! game_id: game.id, user_id: user_id, is_host: true
    GamePlayer.create! game_id: game.id, user_id: opponent.user_id, is_host: false
    game.game_players.each do |player|
      next if player.user.online?

      player.is_host ? game.to_history([0, 3]) : game.to_history([3, 0])
      return TournamentParticipant.find_by(user_id: player.user_id).unearned_lose
    end
    game.send_start_signal
  end

  def unearned_lose
    opponent.index == 1 ? opponent.victory : opponent.win
    destroy
  end

  private

  def check_unearned_win_recursively(index)
    return false if tournament.tournament_participants.exists? index: index

    count = tournament.tournament_participants.count
    return true if Math.sqrt(count).ceil.pow(2) + count < index

    check_unearned_win_recursively(index * 2) && check_unearned_win_recursively(index * 2 + 1)
  end
end
