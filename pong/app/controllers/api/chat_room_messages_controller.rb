module Api
  class ChatRoomMessagesController < RoomMessagesController
    def find_room!
      @room = ChatRoom.find(params[:chat_room_id])
    end

    def check_permission!
      raise ChatRoomsMember::PermissionDenied unless @room.members.exists? id: current_user.id
    end
  end
end
