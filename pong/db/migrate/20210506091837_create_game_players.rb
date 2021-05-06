class CreateGamePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :game_players do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }, index: { unique: true }
      t.references :game, null: false, foreign_key: { to_table: :games }
      t.timestamps
    end
  end
end
