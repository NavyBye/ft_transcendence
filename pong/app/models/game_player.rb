class GamePlayer < ApplicationRecord
  # associations
  belongs_to :user, class_name: "User", foreign_key: :user_id, inverse_of: :game_relation
  belongs_to :game, class_name: "Game", foreign_key: :game_id, inverse_of: :game_players

  # validations
  validates :user_id, uniqueness: true
end
