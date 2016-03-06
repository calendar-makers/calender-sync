class CreateGuests < ActiveRecord::Migration
  def up
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :address
      t.boolean :is_anon
      t.timestamps
    end
  end
  
  def down
    drop_table :guests
  end
end
