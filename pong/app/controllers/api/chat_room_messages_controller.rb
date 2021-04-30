module Api
  class ChatRoomMessagesController < RoomMessagesController
    def find_room!
      ChatRoom.find(params[:chat_room_id])
    end
  end
end
