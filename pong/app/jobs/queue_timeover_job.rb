class QueueTimeoverJob < ApplicationJob
  queue_as :default

  def perform(queue_id)
    return if GameQueue.where(id: queue_id).empty?

    queue = GameQueue.where(id: queue_id).first!
    requested_user = User.find queue.user_id
    war_avoid requested_user if queue.game_type == 'war'
    queue.destroy!

    requested_user.status_update('online') if requested_user.reload.status != 'offline'
    send_signal(requested_user.id, { type: 'refuse' })
  end

  def war_avoid(req_user)
    war = req_user.guild.war
    opposite_wg = WarGuild.where('war_id = ? AND guild_id != ?', war.id, req_user.guild.id).first!
    if opposite_wg.avoid_chance.positive?
      opposite_wg.avoid_chance -= 1
      opposite_wg.save!
    else
      req_user.guild.war_relation.war_point -= 10
      req_user.guild.war_relation.save!
    end
  end
end
