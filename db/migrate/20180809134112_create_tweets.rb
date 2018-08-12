class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.string :tweet_text
      t.decimal :tweet_lat
      t.decimal :tweet_lon
      t.string :tweet_user
      t.datetime :tweet_time
      t.integer :job_id

      t.timestamps
    end
  end
end
