class RenameColumnLabelIdinLabeltoLabelSetId < ActiveRecord::Migration[5.1]
  def change
  	rename_column :labels, :label_id, :label_set_id
  end
end
