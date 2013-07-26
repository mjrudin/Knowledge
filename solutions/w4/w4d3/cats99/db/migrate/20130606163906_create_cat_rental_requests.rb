class CreateCatRentalRequests < ActiveRecord::Migration
  def change
    create_table :cat_rental_requests do |t|
      t.integer :cat_id,  null: false
      t.date :begin_date, null: false
      t.date :end_date,   null: false
      t.string :status,   null: false, default: "undecided"

      t.timestamps
    end

    add_index :cat_rental_requests, :cat_id

  end
end
