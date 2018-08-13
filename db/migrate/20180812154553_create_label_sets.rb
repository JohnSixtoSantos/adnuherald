class CreateLabelSets < ActiveRecord::Migration[5.1]
  def change
    create_table :label_sets do |t|
      t.integer :collection_id
      t.integer :label_id

      t.timestamps
    end
  end
end
