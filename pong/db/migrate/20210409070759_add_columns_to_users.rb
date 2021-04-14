class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_index :users, :name, unique: true
    add_column :users, :provider, :string
    add_index :users, :provider
    add_column :users, :uid, :string
    add_index :users, :uid
    change_table :users, bulk: true do |t|
      t.string :nickname, default: 'newcomer'
      t.integer :status, default: 0
      t.integer :rating, default: 1500
      t.integer :rank
      t.integer :trophy, default: 0
      t.boolean :is_banned, default: false
      t.boolean :is_email_auth, default: false
    end
  end
end
