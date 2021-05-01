module Api
  class DmRoomsController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: serialize(current_user.dm_rooms.where(dm_rooms_members: { exited: false })), status: :ok
    end

    def create
      if params[:user_id].to_i == current_user.id
        return render json: { message: "cannot dm to self" }, status: :bad_request
      end

      current_user.dm_rooms.each do |dm_room|
        if dm_room.dm_rooms_members.exists? user_id: params[:user_id]
          dm_room.dm_rooms_members.update exited: false
          return render json: serialize(dm_room), status: :ok
        end
      end
      render json: serialize(create_dm_room_and_join_members), status: :created
    end

    private

    def create_dm_room_and_join_members
      DmRoom.transaction do
        dm_room = DmRoom.create!
        dm_room.members << [current_user, User.find(params[:user_id])]
        dm_room
      end
    end

    def serialize(dm_room)
      dm_room.as_json only: :id, methods: :name
    end
  end
end
