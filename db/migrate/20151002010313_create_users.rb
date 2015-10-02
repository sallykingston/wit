class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :name, null: false
      t.string :photo
      t.boolean :wit_member, default: false

      t.timestamps null: false
    end

    add_index :users, :provider
    add_index :users, :uid
    add_index :users, :name
    add_index :users, [:provider, :uid], unique: true
  end
end
