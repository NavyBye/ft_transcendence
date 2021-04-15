require "test_helper"

class ChatRoomTest < ActiveSupport::TestCase
  test "chat_room nil" do
    assert_not ChatRoom.new.valid?
    assert_not ChatRoom.new(password: "abcd").valid?
  end

  test "chat_room name" do
    assert_not ChatRoom.new(name: "").valid?
    assert ChatRoom.new(name: "1").valid?
    assert ChatRoom.new(name: "12345").valid?
    assert ChatRoom.new(name: "1234567890").valid?
    assert_not ChatRoom.new(name: "1234567890a").valid?

    # test unique name
    ChatRoom.create!(name: "hyekim")
    assert_not ChatRoom.new(name: "hyekim").valid?
  end

  test "chat_room password auth" do
    password = "12345"
    chat_room = ChatRoom.create(name: "hyekim", password: password)
    assert_not chat_room.encrypted_password.nil?
    assert_equal chat_room.password, password
    assert_not chat_room.public
  end

  test "chat_room name, password" do
    assert_not ChatRoom.new(name: "hyekim", password: "").valid?
    assert_not ChatRoom.new(name: "hyekim", password: "123").valid?
    assert ChatRoom.new(name: "hyekim", password: "1234").valid?
    assert ChatRoom.new(name: "hyekim", password: "12345").valid?
    assert ChatRoom.new(name: "hyekim", password: "1234567890").valid?
    assert_not ChatRoom.new(name: "hyekim", password: "1234567890a").valid?
  end
end
