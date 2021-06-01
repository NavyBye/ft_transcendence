module Chat
  def subscribed
    @room = find_room!
    @self_broadcasting = "#{self.class}.#{@room.id}.#{current_user.id}"
    stream_from @self_broadcasting
    if @room.members.exists? id: current_user.id
      stream_for @room
    else
      self.class.broadcast_to @self_broadcasting, { data: "not member of a room", type: "error" }
    end
  end

  def receive(data)
    return if check_permission

    data["body"] = CGI.escapeHTML(data["body"])
    message = @room.messages.create! user_id: current_user.id, body: data["body"]
    self.class.broadcast_to @room, { data: serialize(message), type: "message" }
  end

  private

  def serialize(message)
    message.as_json only: %i[id user body created_at], include: { user: { only: %i[id nickname image],
                                                                          include: { guild: { only: %i[anagram] } } } }
  end

  def find_room!(); end

  def check_permission
    false
  end
end
