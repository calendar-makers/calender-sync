class AddFieldsToCalendar < ActiveRecord::Migration
  def change
    create_table :calendars
    add_column :calendars, :organization, :string
    add_column :calendars, :event_name, :string
    add_column :calendars, :details, :string
    add_column :calendars, :date, :date
    add_column :calendars, :time, :time
    add_column :calendars, :location, :string
  end
end
