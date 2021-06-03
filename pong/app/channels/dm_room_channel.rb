class DmRoomChannel < ApplicationCable::Channel
  rescue_from ActiveRecord::RecordInvalid, with: :error_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found

  include Chat

  def unsubscribed; end

  private

  def error_invalid(exception)
    DmRoomChannel.broadcast_to @self_broadcasting, { data: exception, type: "error" }
  end

  def error_not_found(exception)
    DmRoomChannel.broadcast_to @self_broadcasting, { data: exception, type: "error" }
  end

  def find_room!
    DmRoom.find params[:id]
  end
end
