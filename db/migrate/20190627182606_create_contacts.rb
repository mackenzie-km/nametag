class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :gender
      t.integer :user_id
      t.integer :phone_number
      t.string :school_status
      t.string :messenger_company
      t.string :messenger_id
      t.string :major
      t.string :country
      t.date :birthday
      t.timestamps
    end
  end
end
