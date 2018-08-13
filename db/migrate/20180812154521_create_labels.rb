class CreateLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :labels do |t|
      t.integer :tweet_id
      t.integer :label
      t.integer :label_id

      t.timestamps
    end
  end
end
