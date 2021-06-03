class WarEndJob < ApplicationJob
  queue_as :default

  def perform(war_id)
    return true if War.where(id: war_id).empty?

    @war = War.find war_id
    @war_history = WarHistory.create!(is_extended: @war.is_extended, is_addon: @war.is_addon,
                                      prize_point: @war.prize_point)
    make_history_guild
    @war.destroy!
  end

  private

  def make_history_guild
    @war.guilds.each do |guild|
      my_point = guild.war_relation.war_point
      op_point = WarGuild.where('war_id = ? AND guild_id != ?', @war.id, guild.id).first!.war_point
      @result = if my_point == op_point
                  'draw'
                else
                  my_point > op_point ? 'win' : 'lose'
                end
      HistoryGuild.create!(war_history_id: @war_history.id, guild_id: guild.id, result: @result)
    end
  end
end
