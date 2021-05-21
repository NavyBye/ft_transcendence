class ChatRoomsMemberBanRecoveryJob < ApplicationJob
  queue_as :default

  def perform(chat_rooms_member_id, ban_at)
    return unless ChatRoomsMember.find(chat_rooms_member_id).ban_at == ban_at

    ChatRoomsMember.update chat_rooms_member_id, ban_at: nil
  end
end
