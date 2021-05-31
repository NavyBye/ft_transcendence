class WarEndJob < ApplicationJob
  queue_as :default

  def perform(war_id)
    @war = War.find war_id
    @war_history = WarHistory.create!(is_extended: war.is_extended, is_addon: war.is_addon,
                                      prize_point: war.prize_point)
    make_history_guild
    war.destroy!
  end

  private

  def make_history_guild
    @war.guilds do |guild|
      result = if guild.war_relation.war_point == guild.war_relation.opposite.war_point
                 'draw'
               elsif guild.war_relation.war_point > guild.war_relation.opposite.war_point
                 'win'
               else
                 'lose'
               end
      HistoryGuild.create!(war_history_id: @war_history.id, guild_id: guild.id, result: result)
    end
  end
end
