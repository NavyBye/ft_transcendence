require "test_helper"
require "json"

class FriendChannelTest < ActionCable::Channel::TestCase
  include ActionCable::TestHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:hyeyoo)
    sign_in @user
  end

  test "subscribe" do
    subscribe id: @user.id
    assert subscription.confirmed?
    assert_has_stream_for @user

    perform :receive, status: "online"
  end
end
