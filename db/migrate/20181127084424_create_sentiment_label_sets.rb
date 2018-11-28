class CreateSentimentLabelSets < ActiveRecord::Migration[5.1]
  def change
    create_table :sentiment_label_sets do |t|
      t.integer :collection_id
      t.integer :label_set_id

      t.timestamps
    end
  end
end
