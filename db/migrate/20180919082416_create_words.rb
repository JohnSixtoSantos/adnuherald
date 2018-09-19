class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.string :word
      t.integer :order_number
      t.integer :topic_id

      t.timestamps
    end
  end
end
