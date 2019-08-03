class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :gender
      t.integer :user_id
      t.integer :phone_number
      t.string :school_status
      t.string :messenger_id
      t.date :last_day
      t.string :major
      t.string :country
      t.date :birthday
      t.integer :admin_level
      t.boolean :newsletter, :default => false
      t.boolean :unsubscribed, :default => false
      t.timestamps
    end
  end
end
