class Invite < ApplicationRecord
  # associations
  belongs_to :user, class_name: "User", foreign_key: :user_id, inverse_of: :invitations
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id, inverse_of: :invitations

  # validations
  validates :guild_id, uniqueness: { scope: :user_id }
end
