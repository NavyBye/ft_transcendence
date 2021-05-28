class QueueTimeoverJob < ApplicationJob
  queue_as :default

  def perform(queue_id)
    return if GameQueue.where(id: queue_id).empty?

    queue = GameQueue.where(id: queue_id).first!
    requested_user = queue.user_id
    queue.destroy!

    requested_user.status_update('online') if requested_user.reload.status != 'offline'
    send_signal(requested_user.id, { type: 'refuse' })
  end
end
