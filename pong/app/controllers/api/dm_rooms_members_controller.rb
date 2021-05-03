module Api
  class DmRoomsMembersController < ApplicationController
    before_action :authenticate_user!
    before_action :find_dm_room!
    before_action :check_permission!

    def index
      render json: serialize(@dm_room.members), status: :ok
    end

    def update
      dm_rooms_member = DmRoomsMember.find_by! user: current_user, dm_room_id: params[:dm_room_id]
      dm_rooms_member.update! exited: params[:exited]
      if dm_rooms_member.exited?
        opponent = DmRoomsMember.find_by! 'user_id != :user_id AND dm_room_id = :dm_room_id',
                                          user_id: current_user.id, dm_room_id: params[:dm_room_id]
        opponent.dm_room.destroy! if opponent.exited?
      end
      render json: {}, status: :ok
    end

    private

    def check_permission!
      raise DmRoomsMember::PermissionDenied unless @dm_room.members.exists? id: current_user.id
    end

    def find_dm_room!
      @dm_room = DmRoom.find params[:dm_room_id]
    end

    def serialize(user)
      user.as_json
    end
  end
end
