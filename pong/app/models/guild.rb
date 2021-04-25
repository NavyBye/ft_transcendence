class Guild < ApplicationRecord
  # associations
  has_many :guild_member_relationship, class_name: "GuildMember", foreign_key: :guild_id,
                                       inverse_of: :guild, dependent: :destroy
  has_many :members, through: :guild_member_relationship, source: :user

  has_many :invitations, class_name: "Invite", inverse_of: :guild, foreign_key: :guild_id, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user

  # validations
  validates :name, length: { in: 4..10 }
  validates :anagram, length: { is: 4 }
  validates :name, :anagram, uniqueness: true
  validates :name, :anagram, :point, presence: true

  # callbacks
  before_validation :strip_string_columns

  private

  def strip_string_columns
    self.name = name.strip unless name.nil?
    self.anagram = anagram.strip unless anagram.nil?
  end
end
