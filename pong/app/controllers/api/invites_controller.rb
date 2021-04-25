module Api
  class InvitesController < ApplicationController
    before_action :authenticate_user!

    def index
      guild = Guild.find(params[:guild_id])
      render json: guild.invitations, status: :ok
    end

    def create
      # TODO : current_user authorization check
      new_invitation = Invite.new(guild_id: params[:guild_id], user_id: params[:user_id])
      new_invitation.save!
      render json: new_invitation, status: :created
    end

    def update
      invitation = Invite.find(params[:id])
      invitation.destroy!
      # TODO : make model method that accept invitation.
      render json: {}, status: :no_content
    end

    def destroy
      invitation = Invite.find(params[:id])
      invitation.destroy!
      # TODO : make model method that refuse invitation.
      render json: {}, status: :no_content
    end
  end
end
