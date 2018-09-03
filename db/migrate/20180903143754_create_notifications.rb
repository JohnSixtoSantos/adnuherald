class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :message
      t.boolean :is_read
      t.string :message_type

      t.timestamps
    end
  end
end
