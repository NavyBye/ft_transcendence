class DmRoomsMember < ApplicationRecord
  belongs_to :dm_room
  belongs_to :user

  validates :user_id, uniqueness: { scope: :dm_room_id }
end
