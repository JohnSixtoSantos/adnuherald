class CreateTopicWords < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_words do |t|
      t.string :word_text
      t.integer :order_number
      t.integer :topic_id

      t.timestamps
    end
  end
end
