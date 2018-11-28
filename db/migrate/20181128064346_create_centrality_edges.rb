class CreateCentralityEdges < ActiveRecord::Migration[5.1]
  def change
    create_table :centrality_edges do |t|
      t.string :source
      t.string :target
      t.integer :size
      t.string :edge_number
      t.string :color
      t.integer :centrality_result_set_id

      t.timestamps
    end
  end
end
