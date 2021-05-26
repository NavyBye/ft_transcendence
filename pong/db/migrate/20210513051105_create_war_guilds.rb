class CreateWarGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table :war_guilds do |t|
      t.references :war, null: false, foreign_key: { to_table: :wars }
      t.references :guild, null: false, foreign_key: { to_table: :guilds }, index: { unique: true }
      t.integer :war_point, default: 0
      t.integer :avoid_chance
      t.timestamps
    end
  end
end
