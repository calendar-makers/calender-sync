class ChangeExpiresFromUser < ActiveRecord::Migration
  def change
    change_column :users, :expires_at, 'integer USING CAST("expires_at" AS integer)'
  end
end
