class AddUniqueIndexToTournamentParticipants < ActiveRecord::Migration[6.1]
  def change
    add_index :tournament_participants, %i[index tournament_id], unique: true
  end
end
