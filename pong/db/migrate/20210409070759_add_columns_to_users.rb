class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_index :users, :name, unique: true
    add_column :users, :provider, :string
    add_index :users, :provider
    add_column :users, :uid, :string
    add_index :users, :uid
    add_column :users, :nickname, :string, default: 'newcomer'
    add_column :users, :status, :integer, default: 0
    add_column :users, :rating, :integer, default: 1500
    add_column :users, :rank, :integer
    add_column :users, :trophy, :integer, default: 0
    add_column :users, :is_banned, :boolean, default: false
    add_column :users, :is_email_auth, :boolean, default: false
  end
end
