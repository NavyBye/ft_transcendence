module Api
  class ChatRoomsController < ApplicationController
    # before_action :authenticate_user!
    def index
      render json: ChatRoom.select(:id, :name).to_json(methods: :public)
    end

    def update
      chat_room = ChatRoom.find(params[:id])
      chat_room.update! chat_room_params
      render json: serialize(chat_room)
    end

    def destroy
      ChatRoom.find(params[:id]).destroy!
      render status: :success
    end

    def create
      chat_room = ChatRoom.create! chat_room_params
      render json: serialize(chat_room), status: :created
    end

    private

    def chat_room_params
      params.permit :name, :password
    end

    def serialize(chat_room)
      chat_room.to_json only: %i[id name], methods: :public
    end
  end
end