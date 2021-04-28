module Api
  class ChatRoomsController < ApplicationController
    before_action :find_chat_room!, only: %i[update destroy]
    before_action :authenticate_user!

    def index
      render json: serialize(ChatRoom.all)
    end

    def index_my_chat_rooms
      render json: serialize(current_user.chat_rooms)
    end

    def update
      @chat_room = ChatRoom.find(params[:id])
      @chat_room.update! chat_room_params
      render json: serialize(@chat_room)
    end

    def destroy
      @chat_room.destroy!
      render json: {}, status: :ok
    end

    def create
      chat_room = ChatRoom.create! chat_room_params
      chat_room.members << current_user
      chat_room.change_role current_user.id, :owner
      render json: serialize(chat_room), status: :created
    end

    private

    def find_chat_room!
      @chat_room = ChatRoom.find params[:id]
    end

    def chat_room_params
      params.permit :name, :password
    end

    def serialize(chat_room)
      chat_room.to_json only: %i[id name], methods: :public
    end
  end
end
