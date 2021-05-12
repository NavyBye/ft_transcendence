class QueueTimeoverJob < ApplicationJob
  queue_as :default

  def perform(queue_id)
    return if GameQueue.where(id: queue_id).empty?

    queue = GameQueue.where(id: queue_id).first!
    requested_user = GameQueue.user_id
    queue.destroy!

    send_signal(requested_user.id, { type: 'refuse' })
  end
end
