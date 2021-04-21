module Api
  class ChatRoomsMembersController < ApplicationController
    before_action :authenticate_user!

    def index
      chat_room = ChatRoom.find(params[:chat_room_id])
      render json: serialize(chat_room.members)
    end

    def create
      chat_room = ChatRoom.find(params[:chat_room_id])
      chat_room.members << current_user
      render json: serialize(User.find(current_user.id)), status: :created
    end

    def update
      ChatRoomsMember.find_by!(user_id: params[:id], chat_room_id: id).update! role: params[:role],
                                                                               status: params[:status]
      render json: serialize(User.find(params[:id]))
    end

    def destroy
      # TODO: validate admin
      ChatRoom.find(params[:chat_room_id]).delete params[:id]
      render json: {}, status: :ok
    end

    private

    def serialize(user)
      user.to_json
    end
  end
end
