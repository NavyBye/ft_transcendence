module Api
  class ChatRoomsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_chat_room!, only: %i[update destroy]
    before_action :check_update_permission!, only: %i[update]
    before_action :check_destroy_permission!, only: %i[destroy]
    after_action :send_fetch_signal, except: %i[index]

    def index
      render json: serialize_with_joined(ChatRoom.all)
    end

    def update
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

    def check_update_permission!
      return unless current_user.user?

      member = @chat_room.chat_rooms_members.find_by user: current_user
      raise ChatRoomsMember::PermissionDenied if member.nil? || member.user?
    end

    def check_destroy_permission!
      return unless current_user.user?

      member = @chat_room.chat_rooms_members.find_by user: current_user
      raise ChatRoomsMember::PermissionDenied if member.nil? || !member.owner?
    end

    def find_chat_room!
      @chat_room = ChatRoom.find params[:id]
    end

    def chat_room_params
      params[:name] = CGI.escapeHTML(params[:name]) unless params[:name].nil?
      params.permit :name, :password
    end

    def send_fetch_signal
      send_global_signal({ type: 'fetch', element: 'chatrooms' })
    end

    def serialize(chat_room)
      chat_room.as_json only: %i[id name], methods: :public
    end

    def serialize_with_joined(chat_rooms)
      chat_rooms.each do |chat_room|
        chat_room.joined = chat_room.members.exists? current_user.id
      end
      chat_rooms = chat_rooms.sort_by { |chat_room| chat_room.joined ? 0 : 1 }
      chat_rooms.as_json only: %i[id name], methods: %i[public joined]
    end
  end
end
