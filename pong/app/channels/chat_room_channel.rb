class ChatRoomChannel < ApplicationCable::Channel
  rescue_from ActiveRecord::RecordInvalid, with: :error_invalid

  def subscribed
    @chat_room = ChatRoom.find(params[:id])
    stream_for @chat_room
  end

  def unsubscribed; end

  def receive(data)
    message = @chat_room.messages.create! user_id: current_user.id, body: data["body"]
    ChatRoomChannel.broadcast_to @chat_room, { data: serialize(message), status: 200 }
  end

  private

  def serialize(message)
    message.to_json only: %i[id user body created_at], include: { user: { only: %i[id nickname] } }
  end

  def error_invalid(exception)
    ChatRoomChannel.broadcast_to @chat_room, { data: exception, status: :bad_request }
  end
end
