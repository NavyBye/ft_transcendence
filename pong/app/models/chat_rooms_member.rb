class ChatRoomsMember < ApplicationRecord
  class PermissionDenied < StandardError; end

  belongs_to :chat_room
  belongs_to :user

  validates :user_id, uniqueness: { scope: :chat_room_id }
  enum status: { normal: 0, muted: 1, banned: 2 }
  enum role: { user: 0, admin: 1, owner: 2 }
end
