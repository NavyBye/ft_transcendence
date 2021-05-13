class WarGuild < ApplicationRecord
  # associations
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :war_relation
  belongs_to :war, class_name: "War", foreign_key: :war_id, inverse_of: :war_relations

  validates :guild_id, uniqueness: true
end
