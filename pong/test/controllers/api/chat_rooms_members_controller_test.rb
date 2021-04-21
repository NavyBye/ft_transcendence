require "test_helper"

class ChatRoomsMembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @chat_room = chat_rooms(:chat_room1)
    sign_in users(:hyekim)
  end

  test "the truth" do
    assert true
  end
end
