class ChatRoomsMember < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user

  enum status: { normal: 0, muted: 1, banned: 2 }
  enum role: { user: 0, admin: 1, owner: 2 }
end
