class AddMeetupColumnsToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :meetup_id, :string
  end
end
