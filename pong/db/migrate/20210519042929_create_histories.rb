class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.integer :game_type, null: false, default: 0
      t.boolean :is_addon, null: false, default: false
      t.timestamps
    end
  end
end
