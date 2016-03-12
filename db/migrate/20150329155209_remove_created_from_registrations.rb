class RemoveCreatedFromRegistrations < ActiveRecord::Migration
  def change
    remove_column :registrations, :created, :string
  end
end
