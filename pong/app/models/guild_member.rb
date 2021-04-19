class GuildMember < ApplicationRecord
  # associations
  belongs_to :guild
  belongs_to :user
  # validations
  validates :user_id, uniqueness: true
end
