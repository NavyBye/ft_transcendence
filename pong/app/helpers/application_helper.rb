module ApplicationHelper
  def token
    {
      csrf_param: request_forgery_protection_token,
      csrf_token: form_authenticity_token
    }
  end

  def check_first_update
    raise User::NeedFirstUpdate if current_user.nickname == 'newcomer'
  end

  def send_signal(id, data)
    check_signal_format data
    user = User.find id
    SignalChannel.broadcast_to user, data
  end

  private

  def check_signal_format(data)
    type = data['type']
    raise SignalChannel::InvalidFormat unless %w[connect fetch].include?(type)

    raise SignalChannel::InvalidFormat if type == 'connect' && data['game_id'].nil?

    raise SignalChannel::InvalidFormat if type == 'fetch' && data['element'].nil?

    true
  end
end
