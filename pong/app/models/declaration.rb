class Declaration < ApplicationRecord
  belongs_to :from, class_name: "Guild"
  belongs_to :to, class_name: "Guild"

  validate :no_self_war
  validate :check_wars
  validate :check_end
  validates :from_id, uniqueness: { scope: :to_id }
  validates :war_time, inclusion: { in: 0..23 }
  validates :avoid_chance, :prize_point, numericality: { greater_than: -1 }

  def accept
    new_war = []
    WarGuild.transaction do
      new_war = War.create!(war_params)
      WarGuild.create!(guild_id: from_id, war_id: new_war.id)
      WarGuild.create!(guild_id: to_id, war_id: new_war.id)
    end
    new_war
  end

  private

  def check_wars
    errors.add(:from_id, 'cannot declare war if already at war.') unless from.war.nil?
    errors.add(:to_id, 'cannot declare war to other guild already at war.') unless to.war.nil?
  end

  def war_params
    {
      end_at: end_at,
      war_time: war_time,
      prize_point: prize_point,
      is_extended: is_extended,
      is_addon: is_addon
    }
  end

  def no_self_war
    errors.add(:from_id, 'a guild cannot declare war to itself.') if from_id == to_id
  end

  def check_end
    errors.add(:end_at, 'a war cannot end at past.') if end_at < Time.zone.now
  end
end
