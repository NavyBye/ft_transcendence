class Invite < ApplicationRecord
  # associations
  belongs_to :user, class_name: "User", foreign_key: :user_id, inverse_of: :invitations
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :invitations

  # validations
  validates :guild_id, uniqueness: { scope: :user_id }
  validate :already_have_guild

  # public methods
  def self.invitable(inviter, inv_guild)
    @role = GuildMember.find_by(user_id: inviter.id, guild_id: inv_guild.id).role
    @role != 'member'
  end

  private

  def already_have_guild
    user = User.find(user_id)
    errors.add(:user_id, 'this user already have a guild.') unless user.guild.nil?
  end
end
