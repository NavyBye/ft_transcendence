class User < ApplicationRecord
  class PermissionDenied < StandardError; end

  mount_uploader :image, UserImageUploader

  # constants & enums
  enum status: { offline: 0, online: 1, game: 2, ready: 3 }
  enum role: { user: 0, admin: 1, owner: 2 }

  # associations
  has_many :friendship_as_user, class_name: "Friend", inverse_of: :user,
                                foreign_key: :user_id, dependent: :destroy
  has_many :friendship_as_follow, class_name: "Friend", inverse_of: :follow,
                                  foreign_key: :follow_id, dependent: :destroy
  has_many :followings, through: :friendship_as_user, source: :follow

  has_many :block_as_user, class_name: "Block", inverse_of: :user,
                           foreign_key: :user_id, dependent: :destroy
  has_many :block_as_blocked_user, class_name: "Block", inverse_of: :blocked_user,
                                   foreign_key: :blocked_user_id, dependent: :destroy
  has_many :blacklist, through: :block_as_user, source: :blocked_user
  has_many :chat_rooms_members, dependent: :destroy
  has_many :chat_rooms, through: :chat_rooms_members
  has_many :dm_rooms_members, dependent: :destroy
  has_many :dm_rooms, through: :dm_rooms_members

  has_one :guild_member_relation, class_name: "GuildMember", inverse_of: :user,
                                  foreign_key: :user_id, dependent: :destroy
  has_one :guild, through: :guild_member_relation, source: :guild

  has_many :invitations, class_name: "Invite", inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :invited_guilds, through: :invitations, source: :guild

  has_one :auth, class_name: "EmailAuth", foreign_key: :user_id, inverse_of: :user, dependent: :destroy

  # validations
  validates :status, inclusion: { in: User.statuses.keys }
  validates :role, inclusion: { in: User.roles.keys }
  validates :nickname, length: { in: 2..20 }
  validates :trophy, numericality: { greater_than: -1 }
  validates :nickname, uniqueness: true, unless: :newcommer?
  validates :name, :nickname, :status, :rating, :trophy, :rank, presence: true
  validates :is_banned, :is_email_auth, exclusion: [nil]

  # callbacks
  before_validation :strip_whitespaces
  before_validation :second_initialize, on: :create

  # devise
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :session_limitable,
         :omniauthable, omniauth_providers: [:marvin]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.nickname
    end
  end

  def self.initial_rank
    return 1 if User.count.zero?

    maximum_rank = User.maximum(:rank)
    maximum_rank_people = User.where(rank: maximum_rank).count
    if maximum_rank_people == maximum_rank
      maximum_rank + 1
    else
      maximum_rank
    end
  end

  def newcommer?
    nickname == 'newcomer'
  end

  private

  def second_initialize
    self.status = 0
    self.rating = 1500
    self.is_banned = false
    self.is_email_auth = false
    self.nickname ||= 'newcomer'
    self.trophy = 0
    self.rank ||= User.initial_rank
    self.name ||= "not42user_#{User.count}"
  end

  def strip_whitespaces
    self.nickname = nickname.strip unless self.nickname.nil?
  end
end
