class CreateCentralityUserHashes < ActiveRecord::Migration[5.1]
  def change
    create_table :centrality_user_hashes do |t|
      t.string :text
      t.float :weight
      t.integer :centrality_result_set_id

      t.timestamps
    end
  end
end
