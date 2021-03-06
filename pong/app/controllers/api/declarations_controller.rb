module Api
  class DeclarationsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_guild

    def index
      render status: :ok
    end

    def create
      new_declaration = Declaration.create!(create_params)
      DeclarationExpireJob.set(wait_until: Time.zone.parse(params[:end_at])).perform_later new_declaration.id
      render json: new_declaration, status: :ok
    end

    def update
      declaration = Declaration.find params[:id]
      error = { type: 'message', message: 'you cannot accept the declaration of other guild.' }
      render json: error, status: :forbidden and return unless declaration.to.id == @guild.id

      new_war = declaration.accept
      @guild.declaration_received.destroy_all
      WarEndJob.set(wait_until: new_war.end_at).perform_later new_war.id
      # TODO : reset
      # WarEndJob.set(wait_until: Time.zone.now + 3.minute).perform_later new_war.id
      render json: {}, status: :no_content
    end

    def destroy
      declaration = Declaration.find params[:id]
      declaration.destroy!
      render json: {}, status: :no_content
    end

    private

    def check_guild
      @guild = current_user.guild
      raise User::PermissionDenied unless GuildMember.find_by(guild_id: @guild.id,
                                                              user_id: current_user.id).role == 'master'
    end

    def create_params
      @opposite_guild = Guild.where(name: params[:to_guild]).first!
      {
        from_id: @guild.id, to_id: @opposite_guild.id,
        end_at: params[:end_at],
        war_time: params[:war_time], tta: params[:tta],
        avoid_chance: params[:avoid_chance], prize_point: params[:prize_point],
        is_extended: params[:is_extended], is_addon: params[:is_addon]
      }
    end
  end
end
