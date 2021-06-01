class ExistsValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, "A tournament already exists" if Tournament.exists?
  end
end

class StartAtValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, "start_at must be future" if record.start_at <= Time.zone.now + 1.minute
  end
end

class Tournament < ApplicationRecord
  class PermissionDenied < StandardError; end

  has_many :tournament_participants, dependent: :destroy
  has_many :participants, through: :tournament_participants, source: :user

  after_create :start_later
  validates :max_participants, numericality: { greater_than_or_equal_to: 4 }
  validates_with ExistsValidator, on: :create
  # validates_with StartAtValidator
  def start
    start_index = Math.log(tournament_participants.count, 2).ceil.pow(2)
    tournament_participants.shuffle.each_with_index do |participant, index|
      participant.update! index: start_index + index + 1
    end
    tournament_participants.each do |participant|
      participant.win while participant.unearned_win? == true
      participant.victory if participant.victoryous?
      next if participant.index.odd? || !participant.opponent?

      participant.create_game
    end
  end

  private

  def start_later
    TournamentStartJob.set(wait_until: start_at).perform_later id
  end
end
