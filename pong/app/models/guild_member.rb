class GuildMember < ApplicationRecord
  # enums
  enum role: { member: 0, officer: 1, master: 2 }

  # associations
  belongs_to :user, class_name: "User", foreign_key: :user_id, inverse_of: :guild_member_relation
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :guild_member_relationship

  # validations
  validates :user_id, uniqueness: true
  validates :role, inclusion: { in: GuildMember.roles.keys }
  validates :user_id, :guild_id, :role, presence: true

  # methods
  def self.update_check(user, member, target_role)
    result = {}
    return result if User.roles[user.role].positive?

    user_member = GuildMember.where(user_id: user.id).first!
    if user_member.guild.id != member.guild.id || user_member.role != 'master'
      result = { 'message' => 'you cannot change the role of other members.', 'status' => :forbidden }
    elsif member.role == 'master' || target_role == 'master'
      result = { 'message' => 'master is immutable role.', 'status' => :bad_request }
    end
    result
  end

  def self.can_destroy?(user, member)
    return true if User.roles[user.role] > User.roles['user']

    # only check guildmaster & myself.
    if user.guild.nil? || user.guild.id != member.guild.id
      false
    elsif GuildMember.find_by(user_id: user.id).role == 'master'
      true
    else
      user.id == member.user_id
    end
  end
end
