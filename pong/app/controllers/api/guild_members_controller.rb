module Api
  class GuildMembersController < ApplicationController
    before_action :authenticate_user!

    def index
      guild = Guild.find(params[:guild_id])
      render json: guild, status: :ok
    end

    def update
      guild_member = GuildMember.find(params[:id])
      guild_member.role = params[:role]
      guild_member.save!
      render json: guild_member, status: :no_content
    end

    def destroy
      guild_member = GuildMember.find(params[:id])
      guild_member.destroy!
      render json: {}, status: :no_content
    end
  end
end
