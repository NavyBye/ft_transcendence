class GuildMember < ApplicationRecord
  # enums
  enum role: { member: 0, officer: 1, master: 2 }

  # assicoations
  belongs_to :user, class_name: "User", foreign_key: :user_id, inverse_of: :guild_member_relation
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :guild_member_relationship

  # validations
  validates :user_id, uniqueness: true
  validates :role, inclusion: { in: GuildMember.roles.keys }
  validates :user_id, :guild_id, :role, presence: true
end
