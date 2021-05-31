class WarGuild < ApplicationRecord
  # associations
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :war_relation
  belongs_to :war, class_name: "War", foreign_key: :war_id, inverse_of: :war_relations

  validates :guild_id, uniqueness: { message: 'a guild cannot join 2 or more war at the same time.' }
end
