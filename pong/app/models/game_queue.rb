class GameQueue < ApplicationRecord
  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }
  validates :user_id, uniqueness: true
end
