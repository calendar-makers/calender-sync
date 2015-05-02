class AddStNumberToEvents < ActiveRecord::Migration
  def change
    add_column :events, :st_number, :string
  end
end
