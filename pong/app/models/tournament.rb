class ExistsValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, "A tournament already exists" if Tournament.exists?
  end
end

class StartAtValidator < ActiveModel::Validator
  def validate(record)
    return unless !record.start_at.nil? && record.start_at <= Time.zone.now + 1.minute

    record.errors.add :base, "start_at must be future"
  end
end

class Tournament < ApplicationRecord
  class PermissionDenied < StandardError; end

  has_many :tournament_participants, dependent: :destroy
  has_many :participants, through: :tournament_participants, source: :user

  after_create :start_later
  validates :max_participants, numericality: { greater_than_or_equal_to: 4 }
  validates :title, presence: true
  validates :start_at, presence: true
  validates_with ExistsValidator, on: :create
  validates_with StartAtValidator

  def start
    destroy_not_playable_users
    tournament_participants.reload
    set_indexes
    tournament_participants.each do |participant|
      participant.win while participant.unearned_win? == true
      participant.victory if participant.victoryous?
      next if participant.index.odd? || !participant.opponent?

      participant.create_game
    end
  end

  private

  def destroy_not_playable_users
    tournament_participants.each do |participant|
      participant.destroy! unless participant.user.online?
    end
  end

  def set_indexes
    start_index = Math.log(tournament_participants.count, 2).ceil.pow(2)
    tournament_participants.shuffle.each_with_index do |participant, index|
      participant.update! index: start_index + index + 1
    end
  end

  def start_later
    TournamentStartJob.set(wait_until: start_at).perform_later id
  end
end
