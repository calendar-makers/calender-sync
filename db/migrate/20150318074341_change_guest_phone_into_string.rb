class ChangeGuestPhoneIntoString < ActiveRecord::Migration
  def change
    change_column :guests, :phone, :string
  end
end
