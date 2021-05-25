class SignalChannel < ApplicationCable::Channel
  class InvalidFormat < StandardError; end

  def subscribed
    @user = User.find params[:id]
    stream_for @user
  end

  def unsubscribed; end

  def receive(data)
    SignalChannel.broadcast_to @user, { data: data, status: :ok }
  end

  private
end
