class CreateCentralityNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :centrality_nodes do |t|
      t.string :label
      t.integer :size
      t.integer :x_pos
      t.integer :y_pos
      t.integer :results_id
      t.integer :centrality_result_set_id

      t.timestamps
    end
  end
end
