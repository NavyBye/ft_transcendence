class CreateDeclarations < ActiveRecord::Migration[6.1]
  def change
    create_table :declarations do |t|
      t.references :from, null: false, foreign_key: { to_table: :guilds }
      t.references :to, null: false, foreign_key: { to_table: :guilds }
      t.index %i[from_id to_id], unique: true
      t.datetime :end_at, null: false
      t.integer :war_time, default: 0
      t.integer :avoid_chance, default: 5
      t.integer :prize_point, default: 420
      t.boolean :is_extended, default: false
      t.boolean :is_addon, default: false
      t.timestamps
    end
  end
end
