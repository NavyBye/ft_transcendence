class Guild < ApplicationRecord
  # associations
  has_many :guild_member_relationship, class_name: "GuildMember", foreign_key: :guild_id,
                                       inverse_of: :guild, dependent: :destroy
  has_many :members, through: :guild_member_relationship, source: :user

  has_many :invitations, class_name: "Invite", inverse_of: :guild, foreign_key: :guild_id, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user

  has_many :declaration_sent, class_name: "Declaration", inverse_of: :from,
                              foreign_key: :from_id, dependent: :destroy
  has_many :declaration_received, class_name: "Declaration", inverse_of: :to,
                                  foreign_key: :to_id, dependent: :destroy

  has_one :war_relation, class_name: "WarGuild", inverse_of: :guild, foreign_key: :guild_id, dependent: :destroy
  has_one :war, through: :war_relation, source: :war

  has_many :war_history_relations, class_name: "HistoryGuild", inverse_of: :guild,
                                   foreign_key: :guild_id, dependent: :destroy
  has_many :war_histories, through: :war_history_relations, source: :war_history

  # validations
  validates :name, length: { in: 4..10 }
  validates :anagram, length: { is: 4 }
  validates :name, :anagram, uniqueness: true
  validates :name, :anagram, :point, presence: true

  # callbacks
  before_validation :strip_string_columns

  # public methods
  def self.can_destroy?(user, guild)
    return true if User.roles[user.role] > User.roles['user']

    role = GuildMember.find_by(user_id: user.id, guild_id: guild.id).role
    role == 'master'
  end

  private

  def strip_string_columns
    self.name = name.strip unless name.nil?
    self.anagram = anagram.strip unless anagram.nil?
  end
end
