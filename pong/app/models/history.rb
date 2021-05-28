class History < ApplicationRecord
  # enum
  enum game_type: Game.game_types

  # associations
  has_many :history_relations, class_name: "HistoryUser", inverse_of: :history, foreign_key: :history_id,
                               dependent: :destroy
  has_many :users, through: :history_relations, source: :user

  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }
end
