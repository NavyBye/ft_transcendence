class CreateGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table :guilds do |t|
      t.string :name, null: false, default: ""
      t.string :anagram, null: false, default: ""
      t.integer :point, null: false, default: 4200

      t.timestamps
    end

    add_index :guilds, :name, unique: true
    add_index :guilds, :anagram, unique: true
  end
end
