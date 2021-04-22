require "test_helper"
require "json"

module Api
  class InvitesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    # index
    test 'get invite list' do
      hyekim_login
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
      hyekim_login
      dummy = users(:dummy)
      post "/api/users/#{dummy.id}/invites"
      assert_response :missing
    end

    test 'invite create success' do
      @user = users(:hyeyoo)
      sign_in @user
      dummy = users(:dummy)
      post "/api/users/#{dummy.id}/invites"
      assert_response :success
    end

    test 'invite create with no right' do
      @user = users(:dummy_member_one)
      sign_in @user
      dummy = users(:dummy)
      post "/api/users/#{dummy.id}/invites"
      assert_response :forbidden
    end

    test 'invite create to already have a guild' do
      hyeyoo = users(:hyeyoo)
      sign_in hyeyoo
      dummy = users(:dummy_member_one)
      post "/api/users/#{dummy.id}/invites"
      assert_response :bad_request
    end

    # update (accept)
    test 'invite accept success' do
      hyekim_login
      inv = @user.invitations.first
      put "/api/users/#{@user.id}/invites/#{inv.id}"
      assert_response :success
      assert_equal result['id'], inv.guild_id
    end

    # destroy (refuse)
    test 'invite refuse success' do
      hyekim_login
      inv = @user.invitations.first
      delete "/api/users/#{@user.id}/invites/#{inv.id}"
      assert_response :no_content
    end

    private

    def hyekim_login
      @user = users(:hyekim)
      sign_in @user
    end

    def result
      @result = JSON.parse @response.body
    end
  end
end
