module Api
  class GuildsController < ApplicationController
    before_action :authenticate_user!

    def index
      @guilds = Guild.all
      render json: @guilds, status: :ok
    end

    def rank
      render json: Guild.all.order(point: :desc), status: :ok
    end

    def my
      if current_user.guild.nil?
        render json: { type: "message", message: "You have no guild." }, status: :not_found
      else
        @guild = current_user.guild
        @master = GuildMember.find_by!(guild_id: @guild.id, role: 'master').user
        render status: :ok
      end
    end

    def show
      @guild = Guild.find(params[:id])
      @master = GuildMember.find_by!(guild_id: @guild.id, role: 'master').user
      render status: :ok
    end

    def histories
      @guild = Guild.find(params[:id])
      render status: :ok
    end

    def create
      @master = current_user
      if @master.guild.nil?
        create_escape
        @guild = Guild.create!(name: params[:name], anagram: params[:anagram], point: 4200)
        @guild_master_join = GuildMember.create!(user_id: @master.id, guild_id: @guild.id, role: 2)
        @master.invitations.destroy_all
        render json: @guild, status: :created
      else
        render json: { type: "message", message: "You already have a guild." }, status: :bad_request
      end
    end

    def destroy
      @guild = Guild.find(params[:id])
      if Guild.can_destroy?(current_user, @guild)
        @guild.destroy!
        render json: {}, status: :no_content
      else
        render json: { type: "message", message: "You have no right to destroy this guild." }, status: :forbidden
      end
    end

    private

    def create_escape
      params[:name] = CGI.escapeHTML(params[:name])
      params[:anagram] = CGI.escapeHTML(params[:anagram])
    end
  end
end
