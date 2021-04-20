class Guild < ApplicationRecord
  # associations
  has_many :guild_member_relationship, class_name: "GuildMember", foreign_key: :guild_id,
                                       inverse_of: :guild, dependent: :destroy
  has_many :members, through: :guild_member_relationship, source: :user

  # validations
  validates :name, length: { in: 4..10 }
  validates :anagram, length: { is: 4 }
  validates :name, :anagram, :point, presence: true

  # callbacks
  before_validation :strip_string_columns, on: :create

  private

  def strip_string_columns
    self.name = name.strip unless name.nil?
    self.anagram = anagram.strip unless anagram.nil?
  end
end
