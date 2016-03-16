class CreateRegistration < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.belongs_to :event, index: true
      t.belongs_to :guest, index: true
    end
  end
end
