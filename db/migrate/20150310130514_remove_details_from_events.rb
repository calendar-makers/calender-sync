class RemoveDetailsFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :details, :string
  end
end
