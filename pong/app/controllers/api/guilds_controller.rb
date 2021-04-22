module Api
  class GuildsController < ApplicationController
    before_action :authenticate_user!
    def index
      render json: Guild.all, status: :ok
    end

    def rank
      render json: Guild.all.order(point: :desc).page(params[:page]), status: :ok
    end

    def my
      if current_user.guild.nil?
        render json: { error: "You have no guild." }, status: :not_found
      end
      @guild = current_user.guild
      render json: @guild, status: :ok
    end

    def show
      @guild = Guild.find(params[:id])
      render json: @guild, status: :ok
    end

    def create
      @master = current_user
      unless master.guild.nil?
        render json: { error: "" }, status: :bad_request
      end
      @guild = Guild.create!(name: params[:name], anagram: params[:anagram], point: 4200)
      @guild_master_join = GuildMember.create!(user_id: @master.id, guild_id: @guild.id, role: 2)
      @master.invitations.destroy_all!
      render json: @guild, status: :created
    end

    def destroy
      @guild = Guild.find(params[:id])
      unless can_destroy?(current_user, @guild)
        render json: { message: "You have no right to destroy this guild." }, status: :forbidden
      end
      @guild.destroy!
      render json: {}, status: :no_content
    end
  end
end
