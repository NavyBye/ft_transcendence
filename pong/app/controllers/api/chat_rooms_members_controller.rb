module Api
  class ChatRoomsMembersController < ApplicationController
    before_action :authenticate_user!
    before_action :find_chat_room!, except: %i[update ban mute free]
    before_action :check_permission!, only: %i[update ban mute free destroy]

    def index
      render json: serialize(@chat_room.members), status: :ok
    end

    def create
      if !@chat_room.public && @chat_room.password != params[:password]
        render json: { message: "password is not correct" }, status: :bad_request
      else
        @chat_room.members << current_user
        render json: serialize(User.find(current_user.id)), status: :created
      end
    end

    def update
      @chat_rooms_member.role = params[:role]
      @chat_rooms_member.save!
      render json: {}, status: :ok
    end

    def destroy
      @chat_room.members.delete params[:id]
      @chat_room.destroy! if @chat_room.members.empty?
      render json: {}, status: :ok
    end

    def ban
      duration = params[:duration].to_i
      raise ActiveRecord::RecordInvalid if duration < 1

      @chat_rooms_member.ban_at = Time.zone.now
      @chat_rooms_member.save!
      ChatRoomsMemberBanRecoveryJob.set(wait: duration.minutes).perform_later @chat_rooms_member.id,
                                                                              @chat_rooms_member.ban_at
      render json: {}, status: :ok
    end

    def mute
      duration = params[:duration].to_i
      raise ActiveRecord::RecordInvalid if duration < 1

      @chat_rooms_member.mute_at = Time.zone.now
      @chat_rooms_member.save!
      ChatRoomsMemberBanRecoveryJob.set(wait: duration.minutes).perform_later @chat_rooms_member.id,
                                                                              @chat_rooms_member.mute_at
      render json: {}, status: :ok
    end

    def free
      @chat_rooms_member.mute_at = nil
      @chat_rooms_member.ban_at = nil
      @chat_rooms_member.save!
      render json: {}, status: :ok
    end

    private

    def find_chat_room!
      @chat_room = ChatRoom.find params[:chat_room_id]
    end

    def check_destroy_self
      params[:action] == "destroy" && params[:id] == current_user.id.to_s
    end

    def check_permission!
      return if check_destroy_self

      @chat_rooms_member = ChatRoomsMember.find_by! user_id: (params[:chat_rooms_member_id] || params[:id]),
                                                    chat_room_id: params[:chat_room_id]
      chat_rooms_current_user = ChatRoomsMember.find_by! user_id: current_user.id, chat_room_id: params[:chat_room_id]
      if chat_rooms_current_user.read_attribute_before_type_cast(:role) <=
         @chat_rooms_member.read_attribute_before_type_cast(:role)
        raise ChatRoomsMember::PermissionDenied
      end
    end

    def serialize(user)
      user.as_json
    end
  end
end
