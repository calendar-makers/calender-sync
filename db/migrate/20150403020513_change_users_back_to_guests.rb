class ChangeUsersBackToGuests < ActiveRecord::Migration
  def self.up
    rename_table :users, :guests
  end

  def self.down
    rename_table :guests, :users
  end
end
