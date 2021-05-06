class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :type, null: false, default: 0
      t.boolean :addon, null: false, default: false

      t.timestamps
    end
  end
end
