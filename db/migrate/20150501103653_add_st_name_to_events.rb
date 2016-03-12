class AddStNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :st_name, :string
  end
end
