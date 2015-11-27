class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :user_id,   null: false
      t.integer :board_id,  null: false
      t.string  :title,     null: false
      t.text    :content,   null: false
      t.timestamps          null: false
    end
  end
end
