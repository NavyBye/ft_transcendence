require "test_helper"
require "json"

module Api
  class DeclarationsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    test "index" do
      login(:hyeyoo)
      get api_declarations_url
      assert_equal result.count, 30
      result_guilds = []
      result.each do |declaration|
        result_guilds.append declaration['from']['id']
      end
      association_guilds = []
      @user.guild.declaration_received.each do |declaration|
        association_guilds.append declaration.from.id
      end
      assert_equal result_guilds.sort, association_guilds.sort
    end

    test "index fail when you are not guild-master" do
      login(:dummy_member_one)
      get api_declarations_url
      assert_response :forbidden
    end

    test "create decl" do
      login(:master)
      opposite_guild = guilds(:one)
      assert_difference 'opposite_guild.reload.declaration_received.count', 1 do
        post api_declarations_url, params: {
          to_guild: opposite_guild.name,
          end_at: Time.zone.now + 10_000,
          war_time: 0, tta: 20,
          avoid_chance: 3, prize_point: 420, is_extended: false, is_addon: false
        }
      end
      assert_response :success
    end

    test "self decl should fail" do
      login(:master)
      opposite_guild = guilds(:test)

      assert_no_difference 'opposite_guild.reload.declaration_received.count', 1 do
        post api_declarations_url, params: {
          to_guild: opposite_guild.name,
          end_at: Time.zone.now + 10_000,
          war_time: 0, tta: 20,
          avoid_chance: 3, prize_point: 420, is_extended: false, is_addon: false
        }
      end
      assert_response :bad_request
    end

    test "accept success and clear other declarations" do
      login(:hyeyoo)
      assert_equal @user.guild.declaration_received.count, 30
      one_declaration = @user.guild.declaration_received.first
      assert_difference 'War.count', 1 do
        put api_declaration_url(one_declaration.id)
      end
      assert_response :success
      assert_equal @user.guild.declaration_received.count, 0
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
