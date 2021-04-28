class FriendChannel < ApplicationCable::Channel
  rescue_from ActiveRecord::RecordInvalid, with: :error_invalid

  def subscribed
    @user = User.find(params[:id])
    stream_for @user
  end

  def unsubscribed; end

  def receive(data)
    @user.update!(status: data["status"])
    FriendChannel.broadcast_to @user, { data: serialize, status: :ok }
  end

  private

  def serialize
    @user.reload.to_json only: %i[id name nickname status]
  end

  def error_invalid(exception)
    FriendChannel.broadcast_to @user, { data: exception, status: :bad_request }
  end
end
