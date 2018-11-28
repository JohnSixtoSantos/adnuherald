class CreateCentralityResultSets < ActiveRecord::Migration[5.1]
  def change
    create_table :centrality_result_sets do |t|
      t.string :description
      t.integer :collection_id

      t.timestamps
    end
  end
end
