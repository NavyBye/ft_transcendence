class Declaration < ApplicationRecord
  belongs_to :from, class_name: "Guild"
  belongs_to :to, class_name: "Guild"

  validate :no_self_war
  validates :from_id, uniqueness: { scope: :to_id }
  validates :war_time, inclusion: { in: 0..23 }
  validates :avoid_chance, :prize_point, numericality: { greater_than: -1 }

  private

  def no_self_war
    errors.add(:from_id, 'a guild cannot declare war to itself.') if from_id == to_id
  end
end
