class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :meetup_id, :string
    add_column :events, :duration, :integer
    add_column :events, :created, :datetime
    add_column :events, :updated, :datetime
    add_column :events, :url, :string
    add_column :events, :how_to_find_us, :string
    add_column :events, :status, :string
  end
end
