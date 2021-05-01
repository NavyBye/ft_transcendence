module Api
  class DmRoomMessagesController < RoomMessagesController
    def find_room!
      @room = DmRoom.find(params[:dm_room_id])
    end

    def check_permission!
      raise DmRoomsMember::PermissionDenied unless @room.members.exists? id: current_user.id
    end
  end
end
