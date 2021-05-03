module Api
  class GuildsController < ApplicationController
    before_action :authenticate_user!
    def index
      render json: Guild.all, status: :ok
    end

    def rank
      render json: Guild.all.order(point: :desc), status: :ok
    end

    def my
      if current_user.guild.nil?
        render json: { message: "You have no guild." }, status: :not_found
      else
        @guild = current_user.guild
        render json: @guild, status: :ok
      end
    end

    def show
      @guild = Guild.find(params[:id])
      render json: @guild, status: :ok
    end

    def create
      @master = current_user
      if @master.guild.nil?
        @guild = Guild.create!(name: params[:name], anagram: params[:anagram], point: 4200)
        @guild_master_join = GuildMember.create!(user_id: @master.id, guild_id: @guild.id, role: 2)
        @master.invitations.destroy_all
        render json: @guild, status: :created
      else
        render json: { message: "You already have a guild." }, status: :bad_request
      end
    end

    def destroy
      @guild = Guild.find(params[:id])
      if Guild.can_destroy?(current_user, @guild)
        @guild.destroy!
        render json: {}, status: :no_content
      else
        render json: { message: "You have no right to destroy this guild." }, status: :forbidden
      end
    end
  end
end
