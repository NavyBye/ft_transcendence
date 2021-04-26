class ChatRoomsMemberUpdateStatusJob < ApplicationJob
  queue_as :default

  def perform(chat_rooms_member_id, status)
    ChatRoomsMember.update chat_rooms_member_id, :status => status
  end
end