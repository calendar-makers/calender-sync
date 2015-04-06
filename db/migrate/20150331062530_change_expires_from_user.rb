class ChangeExpiresFromUser < ActiveRecord::Migration
  def change
    change_column :users, :expires_at, :integer
  end
end
