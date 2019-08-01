class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.date :date
      t.integer :admin_level
      t.integer :staff_count, :default => 0
      t.integer :guest_count, :default => 0
    end
  end
end
