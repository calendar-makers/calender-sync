class AddCreatedUpdatedColumnsToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :created, :datetime
    add_column :registrations, :updated, :datetime
  end
end
