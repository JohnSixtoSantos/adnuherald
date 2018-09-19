class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.integer :topic_result_id
      t.integer :topic_number

      t.timestamps
    end
  end
end
