class AddSourceToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :source, :string
  end
end
