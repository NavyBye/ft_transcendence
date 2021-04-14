class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:marvin]

  enum status: { offline: 0, online: 1, game: 2, ready: 3 }

  before_validation :strip_whitespaces
  after_initialize :second_initialize

  validates :status, inclusion: { in: User.statuses.keys }
  validates :nickname, length: { in: 2..20 }
  validates :trophy, numericality: { greater_than: -1 }
  validates :nickname, uniqueness: true, unless: :newcommer?
  validates :name, :nickname, :status, :rating, :trophy, :rank, presence: true
  validates :is_banned, :is_email_auth, exclusion: [nil]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.nickname
      user.rank = User.initial_rank
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

  private

  def second_initialize
    self.status = 0
    self.rating = 1500
    self.is_banned = false
    self.is_email_auth = false
    self.nickname = 'newcomer'
    self.trophy = 0
    self.rank ||= User.initial_rank
    self.name ||= "not42user_#{User.count}"
  end

  def newcommer?
    nickname == 'newcomer'
  end

  def strip_whitespaces
    self.nickname = nickname.strip unless self.name.nil?
  end
end
