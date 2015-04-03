class RenameGuestToUser < ActiveRecord::Migration
  def self.up
    rename_table :guests, :users
  end

  def self.down
    rename_table :users, :guests
  end
end
