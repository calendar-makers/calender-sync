class AddVenueColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :address_1, :string
    add_column :events, :city, :string
    add_column :events, :zip, :string
    add_column :events, :state, :string
    add_column :events, :country, :string
  end
end
