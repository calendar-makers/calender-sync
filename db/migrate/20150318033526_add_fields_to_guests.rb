class AddFieldsToGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.integer :phone
      t.string :email
      t.string :address
    end
  end
end
