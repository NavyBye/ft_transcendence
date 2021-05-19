class WarHistory < ApplicationRecord
  # associations
  has_many :war_history_relations, class_name: "HistoryGuild", inverse_of: :war_history, foreign_key: :war_history_id,
                                   dependent: :destroy
  has_many :guilds, through: :war_history_relations, source: :guild
end
