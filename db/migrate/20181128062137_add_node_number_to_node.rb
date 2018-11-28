class AddNodeNumberToNode < ActiveRecord::Migration[5.1]
  def change
    add_column :nodes, :node_number, :string
  end
end
