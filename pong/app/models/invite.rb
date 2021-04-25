class Invite < ApplicationRecord
  # associations
  belongs_to :user, class_name: "User", foreign_key: :user_id
  belongs_to :guild, class_name: "Guild", foreign_key: :guild_id

  # validations
  validates :guild_id, uniqueness: { scope: :user_id }
end
