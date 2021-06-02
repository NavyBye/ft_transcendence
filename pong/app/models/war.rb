class War < ApplicationRecord
  has_many :war_relations, class_name: "WarGuild", foreign_key: :war_id, inverse_of: :war, dependent: :destroy
  has_many :guilds, through: :war_relations, source: :guild

  validates :tta, numericality: { greater_than_or_equal_to: 20 }

  def self.timetable
    result = []
    War.find_each do |war|
      result.append(war.war_time)
    end
    result.sort
  end
end
