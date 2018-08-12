class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections do |t|
      t.string :collection_name

      t.timestamps
    end
  end
end
