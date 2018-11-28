class CreateSentiments < ActiveRecord::Migration[5.1]
  def change
    create_table :sentiments do |t|
      t.integer :tweet_id
      t.integer :sentiment_label_set_id
      t.integer :polarity

      t.timestamps
    end
  end
end
