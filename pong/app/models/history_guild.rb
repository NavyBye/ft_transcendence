class HistoryGuild < ApplicationRecord
  # associations
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :war_history_relations
  belongs_to :war_history, class_name: "WarHistory", foreign_key: :war_history_id, inverse_of: :war_history_relations
end
