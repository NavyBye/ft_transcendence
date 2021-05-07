class GameQueue < ApplicationRecord
  # enum
  enum game_type: Game.game_types

  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }
  validates :user_id, uniqueness: true

  # methods
  def self.playable?(user)
    user.status == 'online'
  end
end
