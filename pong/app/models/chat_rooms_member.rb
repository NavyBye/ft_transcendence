class OwnerValidator < ActiveModel::Validator
  def validate(record)
    if record.owner? && ChatRoomsMember.where(chat_room_id: record.chat_room_id).exists? && ChatRoomsMember.where(
      chat_room_id: record.chat_room_id, role: :owner
    ).count == 1
      record.errors.add :base, "This ChatRoom has invalid number of owners"
    end
  end
end

class ChatRoomsMember < ApplicationRecord
  class PermissionDenied < StandardError; end

  belongs_to :chat_room
  belongs_to :user

  validates :user_id, uniqueness: { scope: :chat_room_id }
  validates_with OwnerValidator

  enum status: { normal: 0, muted: 1, banned: 2 }
  enum role: { user: 0, admin: 1, owner: 2 }
end
