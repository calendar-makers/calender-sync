class RegistrationGuestsToUsers < ActiveRecord::Migration
  def change
    drop_table :registrations

    create_table :registrations do |t|
      t.belongs_to :event, index: true
      t.belongs_to :user, index: true
    end
  end
end
