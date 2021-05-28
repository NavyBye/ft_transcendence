class Game < ApplicationRecord
  # enums
  enum game_type: {
    duel: 0,
    ladder: 1,
    ladder_tournament: 2,
    tournament: 3,
    war: 4,
    friendly: 5
  }

  # associations
  has_many :game_players, class_name: "GamePlayer", foreign_key: :game_id, inverse_of: :game, dependent: :destroy
  has_many :players, through: :game_players, source: :user

  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }

  def to_history(scores)
    history = History.create! game_type: game_type, is_addon: addon
    game_players.each_with_index do |player, index|
      history.history_relations.create! user_id: player.user_id, score: scores[index]
    end
    destroy!
    history
  end
end
