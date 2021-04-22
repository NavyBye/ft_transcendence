require "test_helper"
require "json"

module Api
  class GuildsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'guild index' do
      login :hyeyoo
      get '/api/guilds'
      assert_response :success
    end

    test 'guild index 2' do
      login :hyekim
      get '/api/guilds'
      assert_response :success
    end

    test 'guild index without login should fail' do
      get '/api/guilds'
      assert_response :unauthorized
    end

    test 'guild ranks' do
      # TODO : implement guild rank test later.
    end

    test 'guild my' do
      login :hyeyoo
      get '/api/guilds/my'
      assert_response :success
      result
      assert_equal @result['name'], 'testguild'
    end

    test 'guild my have no guild' do
      login :hyekim
      get '/api/guilds/my'
      assert_response :missing
    end

    test 'guild show' do
      login :hyekim
      guild = guilds(:two)
      get "/api/guilds/#{guild.id}"
      assert_response :success
      result
      assert_equal @result['name'], guild.name
    end

    test 'guild create guildscount check' do
      login :hyekim
      assert_difference 'Guild.count', 1 do
        post "/api/guilds", params: { name: 'crTest1212', anagram: 'CRTS' }
      end
      assert_response :created
      assert_equal result['name'], 'crTest1212'
    end

    test 'guild create userguild check' do
      login :hyekim
      assert_changes '@user.reload.guild' do
        post "/api/guilds/", params: { name: 'crTest', anagram: 'CRTS' }
      end
      assert_response :created
      assert_equal result['name'], 'crTest'
    end

    test 'guild create invite auto_destroy' do
      login :hyekim
      assert_difference '@user.invitations.count', -2 do
        post "/api/guilds/", params: { name: 'crTest', anagram: 'CRTS' }
      end
      assert_response :created
      assert_equal result['name'], 'crTest'
    end

    test 'guild create fail when creator already have a guild' do
      login :hyeyoo
      assert_no_changes '@user.guild' do
        post "/api/guilds/", params: { name: 'crTest', anagram: 'CRTS' }
      end
      assert_response :bad_request
    end

    test 'guild destroy' do
      login :master
      guild = guilds(:test)
      assert_difference 'Guild.count', -1 do
        delete "/api/guilds/#{guild.id}"
      end
      assert_response :no_content
    end

    test 'guild destroy member_with_reload' do
      login :master
      guild = guilds(:test)
      @member = users(:member)
      assert_changes '@member.reload.guild.nil?' do
        delete "/api/guilds/#{guild.id}"
      end
      assert_response :no_content
    end

    test 'guild destroy invite' do
      login :master
      guild = guilds(:test)
      assert_difference 'Invite.count', -1 do
        delete "/api/guilds/#{guild.id}"
      end
      assert_response :no_content
    end

    test 'guild destroy with no right to destroy' do
      login :member
      guild = guilds(:test)
      assert_no_difference 'Guild.count' do
        delete "/api/guilds/#{guild.id}"
      end
      assert_response :forbidden
    end

    private

    def login(someone)
      @user = users(someone)
      sign_in @user
    end

    def result
      @result = JSON.parse @response.body
    end
  end
end
