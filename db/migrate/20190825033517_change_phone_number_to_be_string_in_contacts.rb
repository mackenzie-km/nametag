class ChangePhoneNumberToBeStringInContacts < ActiveRecord::Migration[5.2]
  def change
    change_column :contacts, :phone_number, :string
  end
end
