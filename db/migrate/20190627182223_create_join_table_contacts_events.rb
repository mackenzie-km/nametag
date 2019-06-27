class CreateJoinTableContactsEvents < ActiveRecord::Migration[5.2]
  def change
    create_join_table :contacts, :events do |t|
      t.index :contact_id
      t.index :part_id
      t.integer
    end
  end
end
