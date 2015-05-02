class RemoveAddress1FromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :address_1, :string
  end
end
