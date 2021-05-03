class DmRoomsMember < ApplicationRecord
  class PermissionDenied < StandardError; end

  belongs_to :dm_room
  belongs_to :user

  validates :user_id, uniqueness: { scope: :dm_room_id }
end
