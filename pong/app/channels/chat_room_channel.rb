class ChatRoomChannel < ApplicationCable::Channel
  rescue_from ActiveRecord::RecordInvalid, with: :error_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found

  include Chat

  def unsubscribed; end

  private

  def error_invalid(exception)
    ChatRoomChannel.broadcast_to @self_broadcasting, { data: exception, type: "error" }
  end

  def error_not_found(exception)
    ChatRoomChannel.broadcast_to @self_broadcasting, { data: exception, type: "error" }
  end

  def find_room!
    ChatRoom.find params[:id]
  end

  def check_permission
    member = @room.chat_rooms_members.find_by user: current_user
    if member.nil? || !member.mute_at.nil? || !member.ban_at.nil?
      true
    else
      false
    end
  end
end
