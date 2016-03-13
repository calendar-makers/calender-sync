class AddFriendColumnToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :invited_guests, :integer
  end
end
