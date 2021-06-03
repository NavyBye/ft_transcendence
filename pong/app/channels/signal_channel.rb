class SignalChannel < ApplicationCable::Channel
  class InvalidFormat < StandardError; end

  def subscribed
    @user = User.find params[:id]
    stream_for @user
    stream_from "signal:global"
  end

  def unsubscribed; end

  def receive; end
end
