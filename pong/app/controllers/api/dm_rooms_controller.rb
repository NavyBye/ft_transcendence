module Api
  class DmRoomsController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: serialize(current_user.dm_rooms.all), status: :ok
    end

    def create
      current_user.dm_rooms.each do |dm_room|
        if dm_room.members.exists? user_id: params[:user_id]
          return render json: serialize(dm_room), status: :ok
        end
      end
      dm_room = DmRoom.create!
      dm_room.members << [current_user, User.find params[:user_id]]
      render json: serialize(dm_room), status: :created
    end

    private

    def serialize(dm_room)
      dm_room.to_json methods: :name
    end
  end
end
