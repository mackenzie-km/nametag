class ChangeIntegerLimitInContacts < ActiveRecord::Migration[5.2]
  def change
    change_column :contacts, :phone_number, :integer, limit: 8
  end
end
