require "test_helper"
require "json"

module Api
  class InvitesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    # index
    test 'get invite list' do
      login :hyekim
      get "/api/users/#{@user.id}/invites"
      assert_response :success
      result
      @result.each do |invite|
        assert @user.invitations.where(id: invite['id']).exists?
        assert @user.invited_guilds.where(id: invite['guild']['id']).exists?
      end
    end

    # create
    test 'invite create with no guild' do
      login :hyekim
      dummy = users(:dummy)
      assert_no_changes 'dummy.reload.invitations' do
        post "/api/users/#{dummy.id}/invites"
      end
      assert_response :missing
    end

    test 'invite create success' do
      @user = users(:hyeyoo)
      sign_in @user
      dummy = users(:dummy)
      assert_difference 'dummy.reload.invitations.count', 1 do
        post "/api/users/#{dummy.id}/invites"
      end
      assert_response :success
    end

    test 'invite create with no right' do
      @user = users(:dummy_member_one)
      sign_in @user
      dummy = users(:dummy)
      assert_no_changes 'dummy.reload.invitations' do
        post "/api/users/#{dummy.id}/invites"
      end
      assert_response :forbidden
    end

    test 'invite create to already have a guild' do
      hyeyoo = users(:hyeyoo)
      sign_in hyeyoo
      dummy = users(:dummy_member_one)
      assert_no_changes 'dummy.reload.invitations' do
        post "/api/users/#{dummy.id}/invites"
      end
      assert_response :bad_request
    end

    # update (accept)
    test 'invite accept success' do
      login :hyekim
      inv = @user.invitations.first
      assert_changes '@user.reload.guild' do
        assert_difference '@user.invitations.count', -2 do
          put "/api/users/#{@user.id}/invites/#{inv.id}"
        end
      end
      assert_response :success
      assert_equal result['id'], inv.guild_id
    end

    # destroy (refuse)
    test 'invite refuse success' do
      login :hyekim
      inv = @user.invitations.first
      assert_difference '@user.invitations.count', -1 do
        delete "/api/users/#{@user.id}/invites/#{inv.id}"
      end
      assert_response :no_content
    end

    private

    def login(user_fixture_symbol)
      @user = users(user_fixture_symbol)
      sign_in @user
    end

    def result
      @result = JSON.parse @response.body
    end
  end
end
