class ChatRoomsMemberBanRecoveryJob < ApplicationJob
  queue_as :default

  def perform(chat_rooms_member_id, ban_at)
    chat_rooms_member = ChatRoomsMember.find(chat_rooms_member_id)
    return unless chat_rooms_member.ban_at == ban_at

    ChatRoomsMember.update chat_rooms_member_id, ban_at: nil
    broadcast_notification chat_rooms_member.chat_room, chat_rooms_member.user,
                           "#{chat_rooms_member.user.nickname} is now free"
  end

  def broadcast_notification(room, target_user, message)
    ChatRoomChannel.broadcast_to(room,
                                 { type: "notification",
                                   data: { body: message,
                                           user: { id: target_user.id, nickname: target_user.nickname } } })
  end
end
