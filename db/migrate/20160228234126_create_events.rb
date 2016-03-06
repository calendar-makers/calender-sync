class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :name
      t.string :organization
      t.text :description
      t.string :venue_name
      t.integer :st_number
      t.string :st_name
      t.string :city
      t.integer :zip
      t.datetime :start
      t.datetime :end
      t.text :how_to_find_us
      t.integer :meetup_id
      t.string :status
      t.timestamps
    end
  end
  
  def down
    drop_table :events
  end
end
