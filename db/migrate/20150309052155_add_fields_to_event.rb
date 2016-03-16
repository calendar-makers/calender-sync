class AddFieldsToEvent < ActiveRecord::Migration
  def change
    create_table :events
    add_column :events, :organization, :string
    add_column :events, :event_name, :string
    add_column :events, :details, :string
    add_column :events, :date, :date
    add_column :events, :time, :time
    add_column :events, :location, :string
  end
end
