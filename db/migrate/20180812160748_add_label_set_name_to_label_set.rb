class AddLabelSetNameToLabelSet < ActiveRecord::Migration[5.1]
  def change
    add_column :label_sets, :label_set_name, :string
  end
end
