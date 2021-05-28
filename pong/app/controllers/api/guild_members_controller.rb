module Api
  class GuildMembersController < ApplicationController
    before_action :authenticate_user!

    def index
      @guild = Guild.find(params[:guild_id])
      @members = @guild.guild_member_relationship
      render status: :ok
    end

    def update
      guild_member = GuildMember.find_by(user_id: params[:user_id])
      change_master(guild_member) and return if params[:role] == 'master'

      problem = GuildMember.update_check(current_user, guild_member, params[:role])
      if problem['status'].nil?
        guild_member.update!(role: params[:role])
        render json: guild_member, status: :ok
      else
        render json: { type: "message", message: problem['message'] }, status: problem['status']
      end
    end

    def destroy
      guild_member = GuildMember.find_by(user_id: params[:user_id])
      raise User::PermissionDenied unless GuildMember.can_destroy?(current_user, guild_member)

      if guild_member.role == 'master'
        guild_member.guild.destroy!
      else
        guild_member.destroy!
      end
      render json: {}, status: :no_content
    end

    private

    def change_master(guild_member)
      current_member = GuildMember.find_by(guild_id: params[:guild_id], user_id: current_user.id)
      raise User::PermissionDenied if current_user.role == 'user' && current_member.role != 'master'

      render json: guild_member, status: :ok and return if guild_member.role == 'master'

      guild_master = GuildMember.find_by(guild_id: params[:guild_id], role: 'master')
      GuildMember.transaction do
        guild_master.update!(role: 'member')
        guild_member.update!(role: 'master')
      end
      render json: guild_member, status: :ok
    end
  end
end
