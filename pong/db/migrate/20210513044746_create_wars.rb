class CreateWars < ActiveRecord::Migration[6.1]
  def change
    create_table :wars do |t|
      t.datetime :end_at, null: false
      t.integer :war_time
      t.integer :prize_point
      t.boolean :is_extended
      t.boolean :is_addon
      t.timestamps
    end
  end
end
