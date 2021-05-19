class HistoryGuild < ApplicationRecord
  enum result: { win: 0, draw: 1, lose: 2 }

  # associations
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :war_history_relations
  belongs_to :war_history, class_name: "WarHistory", foreign_key: :war_history_id, inverse_of: :war_history_relations

  # validations
  validates :guild_id, uniqueness: { scope: :war_history_id }
  validates :result, inclusion: { in: HistoryGuild.results.keys }
end
