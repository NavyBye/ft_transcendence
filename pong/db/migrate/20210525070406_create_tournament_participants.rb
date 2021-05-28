class CreateTournamentParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :tournament_participants do |t|
      t.references :tournament, null: false, foreign_key: { to_table: :tournaments }
      t.references :user, null: false, foreign_key: { to_table: :users }, index: { unique: true }
      t.integer :index, null: false
      t.timestamps
    end
  end
end
