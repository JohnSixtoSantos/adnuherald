class AddEdgeNumberToEdge < ActiveRecord::Migration[5.1]
  def change
    add_column :edges, :edge_number, :string
  end
end
