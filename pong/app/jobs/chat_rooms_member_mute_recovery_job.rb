class ChatRoomsMemberMuteRecoveryJob < ApplicationJob
  queue_as :default

  def perform(chat_rooms_member_id, mute_at)
    return unless ChatRoomsMember.find(chat_rooms_member_id).mute_at == mute_at

    ChatRoomsMember.update chat_rooms_member_id, mute_at: nil
  end
end
