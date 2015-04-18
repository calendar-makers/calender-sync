class RemoveLocationAndDurationFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :location, :string
    remove_column :events, :duration, :integer
  end
end
