class AddVenueNameToEvent < ActiveRecord::Migration
  def change
    add_column :events, :venue_name, :string
  end
end
