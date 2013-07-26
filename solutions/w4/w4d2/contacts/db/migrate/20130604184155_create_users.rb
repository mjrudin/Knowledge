class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :token

      t.timestamps
    end

    add_index :users, :token, unique: true
    add_index :users, :email, unique: true
  end
end
