class ChatRoomsMemberRecoveryJob < ApplicationJob
  queue_as :default

  def perform(chat_rooms_member_id)
    ChatRoomsMember.update chat_rooms_member_id, status: :normal
  end
end
