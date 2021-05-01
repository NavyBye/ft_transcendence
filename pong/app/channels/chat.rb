module Chat
  def subscribed
    @self_broadcasting = "#{self.class}##{current_user.id}"
    stream_from @self_broadcasting
    @room = find_room!
    unless @room.members.exists? id: current_user.id
      puts "HI loser"
      self.class.broadcast_to @room, { data: "not member of a room", status: 403 }
    else
      puts @room
      stream_for @room
    end
  end

  def receive(data)
    message = @room.messages.create! user_id: current_user.id, body: data["body"]
    self.class.broadcast_to @room, { data: serialize(message), status: 200 }
  end

  private

  def serialize(message)
    message.as_json only: %i[id user body created_at], include: { user: { only: %i[id nickname] } }
  end

  def find_room!(); end
end