module Api
  class ChatRoomMessagesController < RoomMessagesController
    def find_room!
      @room = ChatRoom.find(params[:chat_room_id])
    end

    def check_permission!
      member = @room.chat_rooms_members.where(user_id: current_user.id).first
      raise ChatRoomsMember::PermissionDenied if member.nil? || !member.ban_at.nil?
    end
  end
end
