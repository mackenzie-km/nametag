class AddPrimaryKeyToContactsEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts_events, :id, :primary_key
  end
end
