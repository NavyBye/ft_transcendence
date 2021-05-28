class CreateTournaments < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments do |t|
      t.string :title, null: false
      t.integer :max_participants, null: false, default: 4
      t.boolean :is_ladder, default: false
      t.boolean :is_addon, default: false
      t.timestamps
    end
  end
end
