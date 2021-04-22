require "test_helper"
require "json"

module Api
  class GuildsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'guild index' do
      hyeyoo_login
      get '/api/guilds'
      assert_response :success
    end

    test 'guild index without login' do
      get '/api/guilds'
      assert_response :unauthorized
    end

    test 'guild ranks' do
    end

    test 'guild my' do
    end

    test 'guild show' do
    end

    test 'guild create' do
    end

    test 'guild destroy' do
    end

    private

    def hyeyoo_login
      @user = users(:hyeyoo)
      sign_in @user
    end
  end
end
