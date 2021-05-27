class ChatRoomChannel < ApplicationCable::Channel
  rescue_from ActiveRecord::RecordInvalid, with: :error_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found

  include Chat

  def unsubscribed; end

  private

  def error_invalid(exception)
    ChatRoomChannel.broadcast_to @self_broadcasting, { data: exception, status: :bad_request }
  end

  def error_not_found(exception)
    ChatRoomChannel.broadcast_to @self_broadcasting, { data: exception, status: :not_found }
  end

  def find_room!
    ChatRoom.find params[:id]
  end

  def check_permission
    member = @room.chat_rooms_member.find_by user: current_user
    if member.nil? || !member.mute_at.nil? || !member.ban_at.nil?
      false
    else
      true
    end
  end
end
