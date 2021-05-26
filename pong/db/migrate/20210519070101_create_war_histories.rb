class CreateWarHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :war_histories do |t|
      t.boolean :is_extended, null: false, default: false
      t.boolean :is_addon, null: false, default: false
      t.integer :prize_point, null: false, default: 420
      t.timestamps
    end
  end
end
