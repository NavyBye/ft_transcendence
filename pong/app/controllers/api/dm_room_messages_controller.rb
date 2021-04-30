module Api
  class DmRoomMessagesController < RoomMessagesController
    def find_room!
      DmRoom.find(params[:dm_room_id])
    end
  end
end
