class AddTimestampsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :created_at, :datetime
  end
end
