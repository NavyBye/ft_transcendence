module Api
  class InvitesController < ApplicationController
    before_action :authenticate_user!

    def index
      @invitations = User.find(params[:user_id]).invitations.includes(:guild)
      render status: :ok
    end

    def create
      unless Invite.invitable(current_user, Guild.find(params[:guild_id]))
        render json: { message: 'you cannot invite someone!' }, status: :forbidden
      end
      new_invitation = Invite.new(guild_id: params[:guild_id], user_id: params[:user_id])
      new_invitation.save!
      render json: new_invitation, status: :created
    end

    def update
      @invitation = Invite.find(params[:id])
      accept
      render json: {}, status: :no_content
    end

    def destroy
      invitation = Invite.find(params[:id])
      invitation.destroy!
      render json: {}, status: :no_content
    end

    private

    def accept
      guild = @invitation.guild
      user = @invitation.user
      member = GuildMember.create!(user_id: user.id, guild_id: guild.id)
      user.invitations.destroy_all!
      member
    end
  end
end
