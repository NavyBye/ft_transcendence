module Api
  class GuildMembersController < ApplicationController
    before_action :authenticate_user!

    def index
      guild = Guild.find(params[:guild_id])
      render json: guild.members, status: :ok
    end

    def update
      guild_member = GuildMember.find_by(user_id: params[:user_id])
      problem = GuildMember.update_check(current_user, guild_member, params[:role])
      if problem['status'].nil?
        guild_member.update!(role: params[:role])
        render json: guild_member, status: :ok
      else
        render json: { message: problem['message'] }, status: problem['status']
      end
    end

    def destroy
      guild_member = GuildMember.find_by(user_id: params[:user_id])
      unless GuildMember.can_destroy?(current_user, guild_member)
        render json: { message: '' }, status: :forbidden and return
      end

      if guild_member.role == 'master'
        guild_member.guild.destroy!
      else
        guild_member.destroy!
      end
      render json: {}, status: :no_content
    end
  end
end
