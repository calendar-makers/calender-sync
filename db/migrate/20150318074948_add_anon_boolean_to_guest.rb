class AddAnonBooleanToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :is_anon, :boolean
  end
end
