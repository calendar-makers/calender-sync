class ChangeExpiresFromUser < ActiveRecord::Migration
  def change
    if Rails.env.development?
      change_column :users, :expires_at, :integer
    else
      change_column :users, :expires_at, 'integer USING CAST("expires_at" AS integer)'
    end
  end
end
