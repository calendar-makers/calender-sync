class RemoveCreatedFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :created, :string
  end
end
