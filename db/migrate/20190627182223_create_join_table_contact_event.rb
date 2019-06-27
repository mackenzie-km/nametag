class CreateJoinTableContactEvent < ActiveRecord::Migration[5.2]
  def change
    create_join_table :contacts, :events do |t|
      # t.index [:contact_id, :event_id]
      # t.index [:event_id, :contact_id]
    end
  end
end
