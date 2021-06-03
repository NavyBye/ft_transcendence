class CreateEmailAuths < ActiveRecord::Migration[6.1]
  def change
    create_table :email_auths do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }, index: { unique: true }
      t.string :code
      t.boolean :confirm
      t.timestamps
    end
  end
end
