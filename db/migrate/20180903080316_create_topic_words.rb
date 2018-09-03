class CreateTopicWords < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_words do |t|
      t.integer :topic_number
      t.string :word
      t.integer :order_number
      t.integer :topic_analysis_result_id

      t.timestamps
    end
  end
end
