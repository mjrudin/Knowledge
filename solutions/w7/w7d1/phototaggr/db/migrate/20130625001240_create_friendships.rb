class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :friender_id
      t.integer :friendee_id
      
      t.timestamps
    end
  end
end
