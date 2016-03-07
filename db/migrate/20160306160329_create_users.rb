class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email, null: false
      t.string :encrypted_passcode, null: false
      t.string :reset_password_token, null: false
      t.datetime :reset_password_sent_at
      t.integer :failed_attempts, default: 0, null: false
      t.datetime :locked_at
      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
end
