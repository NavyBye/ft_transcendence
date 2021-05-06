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
end
