class ChangeGuestPhoneIntoString < ActiveRecord::Migration
  def change
    change_column :Guests, :phone, :string
  end
end
