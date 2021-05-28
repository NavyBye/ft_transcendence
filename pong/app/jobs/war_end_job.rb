class WarEndJob < ApplicationJob
  queue_as :default

  def perform(war_id)
    # TODO : make history...
    war = War.find war_id
    war.destroy!
  end
end
