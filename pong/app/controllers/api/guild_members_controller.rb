module Api
  class GuildMembersController < ApplicationController
    before_action :authenticate_user!

    def index
      guild = Guild.find(params[:guild_id])
      render json: guild, status: :ok
    end

    def update
      guild_member = GuildMember.find(params[:id])
      if guild_member.role == 'master' || params[:role] == 'master' || params[:role] == 2
        render json: { error: 'master is immutable role.' }, status: :bad_request
      end
      guild_member.role = params[:role]
      guild_member.save!
      render json: guild_member, status: :no_content
    end

    def destroy
      guild_member = GuildMember.find(params[:id])
      if guild_member.role == 'master'
        guild_member.guild.destroy!
      else
        guild_member.destroy!
      end
      render json: {}, status: :no_content
    end
  end
end
